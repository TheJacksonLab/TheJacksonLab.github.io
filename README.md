## Overview

This is the github repo for The Jackson Lab [website](https://thejacksonlab.web.illinois.edu/wp/). The website uses the static site generator [jekyll](https://jekyllrb.com/) and is based on the [Feeling Responsive jekyll theme](https://github.com/Phlow/feeling-responsive). Development occurs on the dev branch, the live site is located on the master branch.

## Installation

To install this site locally run the following commands:

1. Clone the repo and cd into it `$ git clone git@github.com:TheJacksonLab/TheJacksonLab.github.io.git`
2. Install the bundler `$ gem install bundler`
3. Configure bundler to use local vendor directory:
   ```bash
   mkdir -p .bundle
   echo '---' > .bundle/config
   echo 'BUNDLE_PATH: "vendor/bundle"' >> .bundle/config
   ```
4. Install gems `$ bundle install`
   - Note: On Apple Silicon (ARM64) Macs, you may need to run `$ arch -x86_64 bundle install` to install native extensions correctly
5. Run jekyll and watch for changes:
   ```bash
   bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
   ```
   - On Apple Silicon (ARM64) Macs, you may need to run:
   ```bash
   arch -x86_64 bundle exec jekyll serve --config _config.yml,_config_dev.yml --watch
   ```

The site should now be running on localhost port 4000. Changes to files will show up interactively on localhost:4000

**Note:** The _config.yml and _config_dev.yml files are only read during the initial serve, changing these files will require re-running step 5 for changes to appear.

**Troubleshooting:**
- If you encounter port conflicts, you can specify a different port: `--port 4001`
- If you see errors about missing native extensions (google-protobuf, ffi, etc.), try running under Rosetta 2: `arch -x86_64 bundle exec jekyll serve ...`

## License

The code for this site is licensed under an MIT license, images may have specific attribution requirements and are licensed individually under assets/img/image_attribution
