# Contributing to Streamdeck Audio Player

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## For Cursor AI

If you're a Cursor AI reading this, here's how to properly understand and modify the script:

1. **Script Structure**
   - The script follows a clear flow: argument parsing → validation → process management → execution
   - Each section is clearly commented and separated
   - Security measures are implemented at each step

2. **Key Functions to Understand**
   - `sanitize_path`: Handles file path validation
   - `validate_number`: Ensures numeric inputs are valid
   - Process management section: Handles stopping existing audio

3. **Making Changes**
   - Always maintain the security measures
   - Keep the argument parsing structure
   - Preserve the process management logic
   - Test any changes with both space-separated and equals-sign formats (e.g., `--start 1` and `--start=1`)

4. **Common Patterns**
   - Options are handled in pairs (e.g., `-l|--loop`)
   - Each option has both formats: `-x value` and `-x=value`
   - All numeric inputs are validated
   - All paths are sanitized
   - Process management checks for exact file matches

5. **Testing Changes**
   - Test with existing audio playing
   - Test with invalid inputs
   - Test with different audio devices
   - Test with various option combinations

## Code of Conduct

Please be respectful and considerate of others when contributing to this project.

## How to Contribute

### Reporting Issues

1. Check if the issue has already been reported
2. Use the issue template if available
3. Include as much detail as possible:
   - Operating system
   - mpv version
   - Steps to reproduce
   - Expected behavior
   - Actual behavior

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature/fix
3. Make your changes
4. Test your changes thoroughly
5. Submit a pull request

### Development Guidelines

1. **Code Style**
   - Follow the existing code style
   - Use meaningful variable names
   - Add comments for complex logic
   - Keep functions small and focused

2. **Testing**
   - Test your changes on different platforms if possible
   - Test edge cases
   - Ensure backward compatibility

3. **Documentation**
   - Update README.md if necessary
   - Document new features
   - Update CHANGELOG.md

### Commit Messages

- Use clear and descriptive commit messages
- Reference issues and pull requests when applicable
- Use present tense ("Add feature" not "Added feature")

## Getting Help

If you need help or have questions:
1. Check the existing documentation
2. Look through existing issues
3. Create a new issue if needed

Thank you for contributing! 