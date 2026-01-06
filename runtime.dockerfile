# https://github.com/instructure/canvas-self-hosted
# https://docs.google.com/document/d/1Y9TymZmUOlnr351IQmWslN_TZ_DI-zYBNLZ5y8vWPO8/edit?tab=t.0

FROM canvas-runtime

ENV RAILS_ENV=production
ENV BUNDLE_PATH=/var/canvas/vendor/bundle
ENV LANG=en_US.UTF-8
ENV TZ=Asia/Ho_Chi_Minh
