# tofu-modules

[![npm version](https://img.shields.io/npm/v/tofu-modules.svg)](https://www.npmjs.com/package/tofu-modules) [![License](https://img.shields.io/github/license/nullplatform/tofu-modules.svg)](LICENSE)

## Description

A multi-provider AI-powered README generator that automatically creates documentation for various project types

## Features

- Supports multiple AI providers (Groq, GitHub Models, OpenAI, Anthropic)
- Auto-detects project type (Terraform, TypeScript, Python, generic)
- Generates comprehensive README files with installation and usage
- Includes retry logic with rate limit handling
- Provides CLI with dry-run and verbose modes

## Prerequisites

- Node.js >= 18
- AI provider API key (GROQ_API_KEY, GITHUB_TOKEN, OPENAI_API_KEY, or ANTHROPIC_API_KEY)

## Installation

```bash
npm install tofu-modules
```

## Usage

```typescript
const { detectGenerator, getGeneratorByName } = require('tofu-modules/generators');
```

<!-- BEGIN_API_DOCS -->
<!-- END_API_DOCS -->

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting a PR.

## License

MIT
