## Overview

This is the github repo for The Jackson Lab [website](https://thejacksonlab.web.illinois.edu/wp/). The website uses the static site generator [jekyll](https://jekyllrb.com/) and is based on the [Feeling Responsive jekyll theme](https://github.com/Phlow/feeling-responsive). Development occurs on the dev branch, the live site is located on the master branch.

## Installation

To install this site locally run the following commands:

1. Clone the repo and cd into it `$ git clone git@github.com:TheJacksonLab/TheJacksonLab.github.io.git`
2. **Set up Ruby version management** (required):
   - This project requires Ruby 3.2.9 (specified in `.ruby-version`)
   - If you don't have a Ruby version manager, install **rbenv**:
     ```bash
     # macOS with Homebrew
     brew install rbenv ruby-build
     
     # Initialize rbenv in your shell (add to ~/.zshrc or ~/.bash_profile)
     echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc  # for zsh
     # or
     echo 'eval "$(rbenv init - bash)"' >> ~/.bash_profile  # for bash
     
     # Restart your terminal or run: source ~/.zshrc
     ```
   - Install the required Ruby version:
     ```bash
     rbenv install 3.2.9
     ```
   - The project will automatically use Ruby 3.2.9 when you `cd` into the directory (via `.ruby-version`)
   - Verify: `ruby --version` should show `ruby 3.2.9`
3. Install bundler: `$ gem install bundler`
   - If you see errors about Ruby version, make sure rbenv is initialized and you're using Ruby 3.2.9
4. Configure bundler to use local vendor directory:
   ```bash
   mkdir -p .bundle
   echo '---' > .bundle/config
   echo 'BUNDLE_PATH: "vendor/bundle"' >> .bundle/config
   ```
5. Install gems `$ bundle install`
   - Note: On Apple Silicon (ARM64) Macs, you may need to run `$ arch -x86_64 bundle install` to install native extensions correctly
6. Run jekyll and watch for changes:
   ```bash
   bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
   ```
   - On Apple Silicon (ARM64) Macs, you may need to run:
   ```bash
   arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
   ```

The site should now be running on localhost port 4000. Changes to files will show up interactively on localhost:4000

**Note:** The _config.yml and _config_dev.yml files are only read during the initial serve, changing these files will require re-running step 6 for changes to appear.

**Troubleshooting:**
- **Ruby version errors**: Make sure you're using Ruby 3.2.9 via rbenv. Check with `ruby --version`. If it shows an older version (like 2.6.x), ensure rbenv is initialized in your shell profile and restart your terminal.
- **Bundler installation errors**: If `gem install bundler` fails with "requires Ruby version >= 3.2.0", you're using the wrong Ruby version. Follow step 2 above to set up rbenv.
- If you encounter port conflicts, you can specify a different port: `--port 4001`
- If you see errors about missing native extensions (google-protobuf, ffi, etc.), try running under Rosetta 2: `arch -x86_64 bundle exec jekyll serve ...`

## License

The code for this site is licensed under an MIT license, images may have specific attribution requirements and are licensed individually under assets/img/image_attribution
