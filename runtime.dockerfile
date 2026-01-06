# https://github.com/instructure/canvas-self-hosted
# https://docs.google.com/document/d/1Y9TymZmUOlnr351IQmWslN_TZ_DI-zYBNLZ5y8vWPO8/edit?tab=t.0

FROM canvas-runtime

# Build-time arguments with default values
ARG RAILS_ENV=production
ARG BUNDLE_PATH=/var/canvas/vendor/bundle
ARG LANG=en_US.UTF-8
ARG TZ=Asia/Ho_Chi_Minh

# Set environment variables from build args
ENV RAILS_ENV=${RAILS_ENV}
ENV BUNDLE_PATH=${BUNDLE_PATH}
ENV LANG=${LANG}
ENV TZ=${TZ}
