# Variables
JEKYLL = bundle exec jekyll
PORT = 8080
BUILD_DIR = _site

# Default target
.PHONY: serve
serve:
	@echo "Starting Jekyll server on http://localhost:$(PORT)"
	$(JEKYLL) serve --port $(PORT)

.PHONY: install
install:
	@echo "Installing Jekyll project dependencies..."
	bundle install
	@echo "Dependencies installed successfully."

.PHONY: build
build:
	@echo "Building the Jekyll site..."
	$(JEKYLL) build

.PHONY: clean
clean:
	@echo "Cleaning the site..."
	rm -rf $(BUILD_DIR)

.PHONY: serve-production
serve-production:
	@echo "Serving the Jekyll site in production mode..."
	JEKYLL_ENV=production $(JEKYLL) serve --port $(PORT)

.PHONY: build-production
build-production:
	@echo "Building the Jekyll site in production mode..."
	JEKYLL_ENV=production $(JEKYLL) build

.PHONY: setup
setup:
	@echo "Installing Jekyll and dependencies..."
	sudo apt update
	sudo apt install -y ruby-full build-essential zlib1g-dev
	@if ! grep -q 'export GEM_HOME="${HOME}/gems"' ~/.bashrc; then \
	    echo ''
		echo 'export GEM_HOME="${HOME}/gems"' >> ~/.bashrc; \
	fi
	@if ! grep -q 'export PATH="${HOME}/gems/bin:$$PATH"' ~/.bashrc; then \
		echo 'export PATH="${HOME}/gems/bin:$$PATH"' >> ~/.bashrc; \
	fi
	@echo "Reloading shell configuration..."
	. ~/.bashrc
	export GEM_HOME="${HOME}/gems"
	export PATH="${HOME}/gems/bin:$$PATH"
	gem install --user-install bundler jekyll
	@echo "Jekyll and dependencies installed successfully."

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make serve             - Start Jekyll server"
	@echo "  make build             - Build the Jekyll site"
	@echo "  make clean             - Clean the output directory"
	@echo "  make serve-production  - Serve site in production mode"
	@echo "  make build-production  - Build site in production mode"
	@echo "  make setup             - Install Jekyll and dependencies on Ubuntu"
