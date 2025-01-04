# HealthKeeper

## Installation

### Most recent way with Docker
The most efficient way to set up dev env is to utilize [docker and docker compose](docs/DockerInstallation.md).

### Legacy approach with manual installation
Also, there is an old less efficient way to set up everything by [manually installing all dependencies](docs/ManualInstallation.md).

### Bootstrap and TailwindCSS
As we have both Bootstrap and TailwindCSS installed inside the project we need to split them somehow.
> Thus, to utilize TailwindCSS make sure that you use the classes with the prefix.
If you want to add a `p-1` class then it should be `tw-p-1` now.
But it does not apply to the states, for example, if you want to add a `p-2` on hover, then your class should be `hover:tw-p-2`.

## Useful commands
- In order to reinit everything run `make reinit`. It will drop all containers and recreate everything from the scratch.
### DB management:
- In order to set up DB run `make db:setup`. 
- In order to recreate DB run `make db:reset`. 
- In order to (re)populate DB with a testing data run `make db:seed`.
- In order to apply migrations run `make db:migrate`.
- In order to rollback migrations run `make db:rollback`. It rollbacks 1 migration by default. If you need more, just add a `STEP` option for that: `make db:rollback STEP=2`
### Gem management:
- In order to install all gems from `Gemfile.lock` run `make bundle-install`.
- In order to install a gem run `make bundle-add gem='gem_name'`, e.g. `make bundle-add gem='gmaps4rails'`.
### Others:
- In order to get a list of routes run `make routes`. 
- In order to use generator run `make generate options='generate options'`, e.g. `make generate options='resource student name:string school:belongs_to'`.
- In order to get access to inside the given docker container run `make sh c='container_name'`, e.g. `make sh c='health-keeper-app'`.
There you can do your stuff the same as within manual set up, e.g. run `rails about`.

## Logs
Logs can be obtained by:
- running `make logs`;
- using Docker Desktop: `Containers > Container Name > Logs Tab`.

## How to run the test suite
> You should always run your test suite after using the RuboCop autocorrect functionality: `make lint options='-a'` or `make lint options='-x'`. 
- In order to run all tests run `make rspec`.

> Rspec tests will be run automatically on GitHub actions on creating a PR.

## How to run linter
- In order to run linter (RuboCop in our case) and check your code run `make rubocop`.
- Alternatively you can pass RuboCop a list of files and directories to check `make rubocop options='app spec lib/something.rb'`.
- You can also run RuboCop in an autocorrect mode, where it will try to automatically fix the problems it found in your code `make rubocop options='-a'`.
- You can use RuboCop as a formatter with a handy shortcut to run autocorrection only on code layout (a.k.a. formatting) offenses `make rubocop options='-x'`.
- Also, you can combine different options, e.g. `make rubocop options='-x app spec`.
- For more details check the available command-line options `make rubocop options='-h'`.

> RuboCop will be run automatically on GitHub actions on creating a PR.

### Use linter inside your IDE/Code editor
- For JetBrains RubyMine / Intellij IDEA RuboCop support is [available](https://www.jetbrains.com/help/idea/2017.1/rubocop.html) out of the box as of the 2017.1 releases and further. You don't need to add anything.
- For VSCode you need to install and configure [vscode-rubocop](https://github.com/rubocop/vscode-rubocop) and [ruby-lsp](https://github.com/Shopify/ruby-lsp).

## Troubleshooting

- If you have an error
```
xcrun: error: invalid active developer path (/Library/Developer/CommandLineTools), missing xcrun at: /Library/Developer/CommandLineTools/usr/bin/xcrun
```
while running `make` command - you [need to install](https://apple.stackexchange.com/questions/254380/why-am-i-getting-an-invalid-active-developer-path-when-attempting-to-use-git-a) the `Xcode Command Line Tools` (run `xcode-select --install`) or reset it if has been already done (run `xcode-select --reset`).

## App scope to be done

### **High Priority**

1. [ ] **Health Data Management**
   - [ ] User Story 1: Manual input of blood test results.
   - [ ] User Story 2: Import health data from PDF files.
   - [x] User Story 4: Display health data with color-coded references.
2. [ ] **User Interface and Experience**
   - [ ] User Story 16: See trends in health data over a defined period.
3. [x] **Biomarker and Disease Database**
   - [x] User Story 22: Allow users to add their own reference databases.
4. [x] **Security**
   - [x] Authentication.
   - [x] Authorization.
   - [x] Role management.
      - [x] Tune role policies.
5. [x] Wrap an app in Docker.