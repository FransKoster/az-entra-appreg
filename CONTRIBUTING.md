# Contributing to az-entra-appreg

Thank you for your interest in contributing to this project! Here are some guidelines to help you get started.

## How to Contribute

1. Fork the repository
2. Create a new branch for your feature or bugfix
3. Make your changes
4. Test your changes thoroughly
5. Submit a pull request

## Development Guidelines

### Code Style

- Follow Terraform best practices
- Use `terraform fmt` to format your code before committing
- Write clear, descriptive variable names and comments
- Keep configurations DRY (Don't Repeat Yourself)

### Testing

Before submitting a pull request:

1. Run `terraform fmt -recursive` to format all files
2. Run `terraform validate` on the root module and all examples
3. Test your changes with actual Azure Entra ID resources if possible
4. Update documentation to reflect any changes

### Documentation

- Update the README.md if you add new features
- Add examples for new functionality
- Keep the CHANGELOG.md updated with your changes
- Document any new variables or outputs

### Commit Messages

- Use clear and descriptive commit messages
- Reference any related issues in your commit messages
- Keep commits atomic and focused on a single change

## Reporting Issues

If you find a bug or have a feature request:

1. Check if the issue already exists
2. Create a new issue with a clear title and description
3. Include steps to reproduce for bugs
4. Include examples or use cases for feature requests

## Code of Conduct

Please be respectful and constructive in all interactions. We aim to maintain a welcoming and inclusive community.

## Questions?

Feel free to open an issue for any questions about contributing.

Thank you for contributing!
