---
layout: docs
title: Reflex Actions
permalink: /docs/reflex-actions/
---

Actions define a sequence of events which are triggered, usually from some form of deploy, build process, automation, or launch control.  Actions are stored within your source code as a JSON file, rather than in Reactor Engine.

Commonly actions are used as a platform uniform way to trigger scripts such as build, deploy, setup, and launch, all independent of if you are running Node, Java, Ruby or any other language.

Actions can be triggered by the action CLI, and even by Launch Control.  The name of the action is defined in the actions portion of the configuration (see Configuring Actions).  To run a build action:

	action do build

It might be useful to import in the Reactor Engine defined environment to an Action script.  To trigger an action from Launch Control, include :action  after the service name.  For example, if your action was launch you would run:


	launch service bct:launch

This will take the configurations from Reactor Engine for  bct  and will merge into it the local reflex action configurations, and then will run the action  launch .

More Details are available in the Actions Reference section.

# Configuring Actions

Actions are configured in the folder  .reflex/ , which is always relative to the current working directory.  Within the reflex actions configuration folder is a JSON file named config, such as: `.reflex/config.json`.

Action configurations are not the same as configurations in Reactor Engine, although the Reactor Engine configurations may be imported and merged into the Action configuration if the action is run from launch control (see Triggering Actions).

An action configuration is structured with three base elements: config, setenv, and actions, each which has a json object as a value.  An example:

{% highlight json %}
{
    "config": {
        "active-copies": 1
    },
    "setenv": {
        "COPIES": "${active-copies}"
    },
    "actions": {
        "copies": {
            "exec": ["echo", "copies=${COPIES}"],
            "type": "system"
        }
    }
}
{% endhighlight %}

The config object is one level deep, and defines ad-hoc configurations relevant to the local actions, which should not or do not belong in the environment.  Configuration values stored in the config object are similar to sensitive.parameters on the Reactor Engine configuration, in that they may be included with variable substitution on setenv and system run lines.

The setenv object is one level deep, and defines global environment variables that should be set for all actions.  Variable substitution is performed searching values first from the OS environment, then the config object, and follows the syntax:  ${VARIABLE} .

The actions object is many levels deep, with the first level key being the name of the action.  Within each action there are additional variables which may be defined, depending upon the type of action.  The following action types are defined:

* script -- run the designated script (located in the .reflex folder)
* system -- run the target array on the system
* group -- run a set of actions in order
* roll-package -- roll a package as defined
* store-package-s3 -- store a package into s3 (usually run after roll-package)

The options available on actions are described as followed, based on the type of action:

{: .table .values }
Types | Value | Description
----|-----|----
onSuccess | string | Name of target to run, if current action succeeds.
setenv | object | Similar to setenv at the global level, but specific to a single action.
title | string | (optional) title used in printing action banners.  If undefined, the action name is used instead.
type| string| one of: defined types for the action (shown above).
target | string | Value is taken as a script located in the .reflex folder.

**Type = `system`**

{: .table .values }
Type|  value|  Description
-|-|-|-
exec | array of strings | Array is sent as arguments to the system exec(), with the first argument being the program to run.  Each string in the array is processed for variable substitution, just as with elements of setenv. |
config | "stdin" | If defined, the value is "stdin" and it is called from launch control, then the configuration is written to the STDIN of the exec process. |

**Type = `group`**

{: .table .values }
Type|  value|  Description
-|-|-|-
actions | array of strings | Each element in the array is another action target. |

**Type = `roll-package`**

{: .table .values }
Type|  value|  Description
-|-|-|-
exclude | string | (optional) name of file found in .reflex folder, which is used as exclude options to rolling the package (tarball). |
include | string | name of file found in .reflex folder, which is used as include options to rolling the package (tarball). |
chdir | string | Before rolling tarball, change current working directory to defined path. |
gitignore | true | If true, include .gitignore as excludes. |


