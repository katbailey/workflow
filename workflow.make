core = 6.x

; Contrib
projects[admin_menu][subdir] = "contrib"
projects[admin_menu][version] = "1.5"

projects[cck][subdir] = "contrib"
projects[cck][version] = "2.7"

projects[date][subdir] = "contrib"
projects[date][version] = "2.4"

projects[ctools][subdir] = "contrib"
projects[ctools][version] = "1.6"

projects[features][subdir] = "contrib"
projects[features][version] = "1.0-beta8"

projects[features_extra][subdir] = "contrib"
projects[features_extra][version] = "1.x-dev"

projects[pathauto][subdir] = "contrib"
projects[pathauto][version] = "1.3"

projects[token][subdir] = "contrib"
projects[token][version] = "1.13"

projects[views][subdir] = "contrib"
projects[views][version] = "2.11"

projects[job_queue][subdir] = "contrib"
projects[job_queue][version] = "3.1"

projects[install_profile_api][subdir] = "contrib"
projects[install_profile_api][version] = "2.x-dev"

projects[nodequeue][subdir] = "contrib"
projects[nodequeue][version] = "2.9"

projects[nodequeue_randomizer][subdir] = "contrib"
projects[nodequeue_randomizer][version] = "1.0-rc1"

projects[nodewords][subdir] = "contrib"
projects[nodewords][version] = "1.11"

projects[imageapi][subdir] = "contrib"
projects[imageapi][version] = "1.8"

projects[imagecache][subdir] = "contrib"
projects[imagecache][version] = "2.0-beta10"

projects[filefield][subdir] = "contrib"
projects[filefield][version] = "3.5"

projects[imagefield][subdir] = "contrib"
projects[imagefield][version] = "3.3"

; Development

projects[devel][subdir] = "development"
projects[devel][version] = "1.20"

; Workflow - Contrib
projects[deploy][subdir] = "workflow/contrib"
projects[deploy][version] = "1.x-dev"
projects[deploy][patch][] = "http://drupal.org/files/issues/deploy-805966-4.patch"

projects[services][subdir] = "workflow/contrib"
projects[services][version] = "2.2"
projects[services][patch][] = "http://drupal.org/files/issues/services_pressflow.patch"
projects[services][patch][] = "http://drupal.org/files/issues/services_cache_0.patch"

projects[settings_audit_log][subdir] = "workflow/contrib"
projects[settings_audit_log][version] = "1.0-alpha1"

; Workflow - Custom
projects[incremental_deploy][subdir] = "workflow/custom"
projects[incremental_deploy][type] = "module"
projects[incremental_deploy][download][type] = "git"
projects[incremental_deploy][download][url] = "git://github.com/katbailey/incremental_deploy.git"

projects[nodequeue_deploy][subdir] = "workflow/custom"
projects[nodequeue_deploy][type] = "module"
projects[nodequeue_deploy][download][type] = "git"
projects[nodequeue_deploy][download][url] = "git://github.com/katbailey/nodequeue_deploy.git"

projects[nodewords_deploy][subdir] = "workflow/custom"
projects[nodewords_deploy][type] = "module"
projects[nodewords_deploy][download][type] = "git"
projects[nodewords_deploy][download][url] = "git://github.com/katbailey/nodewords_deploy.git"

projects[custom_services][subdir] = "workflow/custom"
projects[custom_services][type] = "module"
projects[custom_services][download][type] = "git"
projects[custom_services][download][url] = "git://github.com/katbailey/custom_services.git"

projects[sourcecontrol][subdir] = "workflow/custom"
projects[sourcecontrol][type] = "module"
projects[sourcecontrol][download][type] = "git"
projects[sourcecontrol][download][url] = "git://github.com/katbailey/sourcecontrol.git"

