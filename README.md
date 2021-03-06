
# egsfree

![Demo animation](demo_anim.svg "Demo animation")

Simple cli to find out what are the current and future free games on the EpicGamesStore.

## Installation

Download a binary from the [Releases](https://github.com/zkayia/egsfree/releases/latest) tab or [Build](#Build) one.

Then add the binary to your OS's PATH or specify the full path in the terminal.

## Usage

* Get current free games:
```
egsfree get [arguments]

Arguments:
   -h, --help              Print this usage information.
   -a, --[no-]all          Display all other free games.
   -l, --locale=<en-US>    The locale to use when fetching data.
   -c, --country=<US>      The country to use when fetching data.
```
The locale and country arguments can be set in the config.

* View the config file path:
```
egsfree config path [arguments]  

Arguments:
   -h, --help        Print this usage information.
   -a, --[no-]all    Displays the path for every OS.
```
Defaults to `%USERPROFILE%\.config\egsfree.json` on Windows and `~\.config\egsfree.json` on Linux, Mac, ... 


* View config values
```
egsfree config get [key key2 ...]
```
To view all current config keys and values, run `egsfree config get`.

* Edit config values
```
egsfree config set [arguments]

Arguments:
   -h, --help              Print this usage information.
   --key=<value>
   --key2=<value2>
```
Running `egsfree config set --help` will show all possible keys and their default values.

* (1.0.2+) Display current and latest version
```
egsfree --version
```
* (1.2.0+) Update or downgrade
```
egsfree update [arguments]

Arguments:
   -h, --help          Print this usage information.
   -v, --version       The version to update to.
   -f, --[no-]force    Force an update to the given/latest version even if it's the one currently installed.
```
Running `egsfree update -f -v=<your-current-version>` will reinstall the cli. You can omit the `-v` option if you're running latest.


## Build

1. Clone this repo:
   ```
   git clone https://github.com/zkayia/egsfree
   ```

2. Make sure your installed sdk fits the requirement in the [pubspec.yaml](pubspec.yaml) file (under `environment` > `sdk`).

3. Navigate to the project's root folder.

4. Install dependencies:
   ```
   dart pub get
   ```

5. Run it:
   ```
   dart run ./bin/egsfree.dart
   ```

   Or compile it ([more info on dart compile](https://dart.dev/tools/dart-compile)):
   ```
   dart compile exe ./bin/egsfree.dart
   ```  
