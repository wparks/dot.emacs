# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Emacs configuration stored in ~/.emacs.d/. The configuration uses `use-package` for package management and follows a modular approach with separate files for initialization and customization.

## Architecture

- **init.el**: Main configuration file containing package setup, UI configuration, editor settings, and mode configurations
- **custom.el**: Emacs-generated customization file for user preferences and package settings
- **elpa/**: Package directory managed by Emacs package system (MELPA and GNU ELPA)
- **tmp/**: Directory for backups and auto-saves (created automatically)

## Key Configuration Structure

The init.el follows this pattern:
1. Package system setup (MELPA/GNU repositories)
2. use-package installation and setup
3. Custom file loading
4. Window system configuration (GUI-specific settings)
5. Editor backup/autosave configuration
6. Basic editor settings
7. Theme and visual configuration
8. Mode-specific configurations using use-package

## Package Management

- Uses `use-package` for declarative package configuration
- Packages are automatically installed from MELPA and GNU ELPA
- Package configurations include defer loading, hooks, and custom settings
- Custom settings are stored separately in custom.el

## Current Configuration Features

- Spacemacs dark theme
- Line numbers for programming modes
- Whitespace visualization with custom display mappings
- LSP mode support (currently deferred)
- Flycheck integration
- Rustic mode for Rust development
- Desktop session persistence
- Comprehensive backup system in tmp/ directory

## TODO Items in Configuration

The init.el contains several commented TODO sections for future implementation:
- Indentation guides (highlight-indent-guides)
- IDO completion system
- Company mode for autocompletion
- Org mode configuration
- Magit for Git integration
- Additional language modes (C/C++, Python, JSON, YAML, Go, Markdown)

## Emacs Usage

To reload configuration: `M-x eval-buffer` in init.el or restart Emacs
To customize settings: Use `M-x customize` (saves to custom.el)
To install packages: Add use-package declaration to init.el and restart/reload