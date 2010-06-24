<?php
// $Id$

require_once('profiles/default/default.profile');

/**
 * Return a description of the profile for the initial installation screen.
 *
 * @return
 *   An array with keys 'name' and 'description' describing this profile,
 *   and optional 'language' to override the language selection for
 *   language-specific profiles.
 */
function workflow_profile_details() {
  return array(
    'name' => 'workflow',
    'description' => 'Workflow installation profile.'
  );
}

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * @return
 *   An array of modules to enable.
 */
function workflow_profile_modules() {
  global $conf;

  $core = array(
    // Required core modules.
    'block', 'filter', 'node', 'system', 'user',

    // Optional core modules.
    'dblog', 'help', 'menu', /*'search',*/ 'taxonomy', 'update', 'path',
    /*'comment',*/ 'statistics', /*'profile',*/

    // More optional core modules
    /* 'contact',*/ 'translation', 'locale', 
  );

  $contrib = array(
    // Makes install profile setup simpler
    'install_profile_api',

    // SEO
    'token', 'pathauto',
    'nodewords', 'nodewords_basic', 'nodewords_extra',

    // CCK modules.
    'content', 'content_copy', 'text', 'date_api', 'date',
    'fieldgroup', 'optionwidgets', 'filefield', 'imagefield',
    'number', 'nodereference',

    // Images
    'imageapi', 'imageapi_gd', 'imagecache', 'imagecache_ui',

    // Custom pages and layouts
    'views', 'views_ui', 'ctools',


    // Administration and helpers
    'nodequeue', 'job_queue', 'admin_menu', 'features', 'fe_nodequeue',
    'nodequeue_randomizer',

  );

  $workflow = array('deploy_uuid');
  $workflow_source = array();
  $workflow_target = array();

  if (isset($conf['deploy']['target'])) {
    $workflow_source = array(
      // Deploy modules
      'deploy', 'user_deploy', 'node_deploy', 'filefield_deploy', 
      'nodereference_deploy', 'taxonomy_deploy',
    );
  }

  if (isset($conf['deploy']['is_target']) && $conf['deploy']['is_target'] == TRUE) {
    $workflow_target = array(
      // Services modules
      'services', 'services_keyauth', 'xmlrpc_server', 'system_service', 'user_service', 
      'file_service', 'node_service', 'taxonomy_service', 
      'custom_services', 'incdep_service',
    );
  }
  $pressflow = default_profile_modules();

  return array_merge($pressflow, $core, $contrib, $custom, $workflow, $workflow_source, $workflow_target);
}

/**
 * Return a list of tasks that this profile supports.
 *
 * @return
 *   A keyed array of tasks the profile will perform during
 *   the final stage. The keys of the array will be used internally,
 *   while the values will be displayed to the user in the installer
 *   task list.
 */
function workflow_profile_task_list() {
  return array();
}

/**
 * Implementation of hook_profile_tasks().
 */
function workflow_profile_tasks(&$task, $url) {
  install_include(workflow_profile_modules());

  $operations = array(
    // General site setup
    array('workflow_profile_batch_dispatcher', array('_workflow_setup_general', array())),

    // Setup users
    array('workflow_profile_batch_dispatcher', array('_workflow_setup_users', array())),

    // Setup cck type, nodequeue, view and imagecache for features nodequeue
    array('workflow_profile_batch_dispatcher', array('install_content_copy_import_from_file', array('profiles/workflow/photo.cck.inc'))),
    array('workflow_profile_batch_dispatcher', array('_workflow_setup_features_queue', array())),

  );
  if (isset($conf['deploy']['is_target']) && $conf['deploy']['is_target'] == TRUE) {
    // Setup services
    $operations[] = array('workflow_profile_batch_dispatcher', array('_workflow_setup_services', array()));
  }
  if (isset($conf['deploy']['target'])) {
    // Setup deploy
    $operations[] = array('workflow_profile_batch_dispatcher', array('_workflow_setup_incdep', array()));
  }
  batch_set(array(
    'title' => 'Setting up workflow Install Profile',
    'operations' => $operations,
    'file' => 'profiles/workflow/workflow.profile',
  ));
  batch_process();
}


/**
 * Batch API callback: Dispatches batches and loads install_profile_api helpers.
 **/
function workflow_profile_batch_dispatcher($function, $arguments) {
  install_include(workflow_profile_modules());

  $ret = call_user_func_array($function, $arguments);

  foreach (form_set_error(NULL, '', TRUE) as $field => $message) {
    drupal_set_message($message, 'error');
  }

  return $ret;
}

/**
 * General site setup.
 **/
function _workflow_setup_general() {
  // some variable_sets?
}


/**
 * Setup pre-fab accounts.
 **/
function _workflow_setup_users() {
  global $conf;
  if (isset($conf['deploy']['is_target']) && $conf['deploy']['is_target'] == TRUE) {
    // Create the delpoy user
    install_add_user(
      'deploy',
      'deploy123', // The password is stored in the settings.php file for the current site
      'deploy@' . $_SERVER['HTTP_HOST'],
      array('deployer'),
      1
    );
  }
}

/**
 * Setup nodequeues
 *
 **/
function _workflow_setup_features_queue() {

  // create the Features nodequeue
  $qid = install_nodequeue_create('Features', array(), array('photo'), 8);
  // Add the machine name for deployability
  db_query("INSERT INTO {fe_nodequeue_queue} (qid, machine_name) VALUES (%d, 'features')", $qid);
  
  // create the imagecache preset
  module_load_include('module', 'imagecache');
  module_load_include('inc', 'imagecache', 'imagecache_actions');
  $preset = imagecache_preset_save(array(
    'presetname' => 'sqaure',
  ));
  imagecache_action_save(array(
    'action' => 'imagecache_scale_and_crop',
    'weight' => 0,
    'presetid' => $preset['presetid'],
    'data' => array('width' => 200, 'height' => 200),
  ));
  
  // create view of featured items
  install_views_ui_import_from_file($views . 'profiles/workflow/features.view.inc');
}

/**
 * Set up deploy
 */
function _workflow_setup_incdep() {
  include_once './includes/install.inc';
  $modules = array('settings_audit_log', 'incremental_deploy', 'nodequeue_deploy', 'nodewords_deploy', 'sourcecontrol');
  drupal_install_modules($modules);
}

/**
 * Setup services.
 **/
function _workflow_setup_services() {
  global $conf;

  // Services settings
  variable_set('services_auth_module', 'services_keyauth');
  variable_set('services_use_sessid', 1);
  variable_set('services_use_key', 0);
}

/**
 * Implementation of hook_form_alter().
 *
 * Allows the profile to alter the site-configuration form. This is
 * called through custom invocation, so $form_state is not populated.
 */
function workflow_form_alter(&$form, $form_state, $form_id) {
  if ($form_id == 'install_configure') {
    global $conf;
    // Set default for site name field.
    $form['site_information']['site_name']['#default_value'] = (isset($conf['deploy']['is_target']) && $conf['deploy']['is_target'] == TRUE) ? 'Workflow Target' : 'Workflow Source';
  }
}
