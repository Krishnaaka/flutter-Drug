# Build stage
FROM debian:latest AS build

# Install dependencies
RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa wget

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor
RUN flutter config --enable-web

WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Run stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
# Custom nginx config to handle SPA routing if needed
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
