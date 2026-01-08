# Publishing dd-apscheduler to PyPI

This guide explains how to publish the `dd-apscheduler` package to PyPI.

## Prerequisites

1. **PyPI Account**: Create an account at https://pypi.org/account/register/
2. **TestPyPI Account**: Create an account at https://test.pypi.org/account/register/
3. **API Tokens**: Generate API tokens from your account settings:
   - PyPI: https://pypi.org/manage/account/token/
   - TestPyPI: https://test.pypi.org/manage/account/token/

## Step 1: Update Package Metadata

Before publishing, update the following in `pyproject.toml`:
- `authors`: Replace "Your Name" and "your.email@example.com" with your details
- `[project.urls]`: Update GitHub URLs to your repository

## Step 2: Test on TestPyPI First

**Always test on TestPyPI before publishing to production PyPI!**

### Build the package:
```bash
source venv/bin/activate
python -m build
```

### Upload to TestPyPI:
```bash
python -m twine upload --repository testpypi dist/*
```

You'll be prompted for:
- Username: `__token__`
- Password: Your TestPyPI API token

### Test installation from TestPyPI:
```bash
pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ dd-apscheduler
```

### Verify it works:
```bash
python -c "import apscheduler; print('Success!')"
```

## Step 3: Publish to Production PyPI

Once you've verified the TestPyPI version works:

### Upload to PyPI:
```bash
python -m twine upload dist/*
```

You'll be prompted for:
- Username: `__token__`
- Password: Your PyPI API token

### Verify installation:
```bash
pip install dd-apscheduler
python -c "import apscheduler; print('Success!')"
```

## Step 4: Updating the Package

For future releases:

1. Update version in `pyproject.toml`:
   ```toml
   version = "1.0.1"  # Increment as needed
   ```

2. Rebuild and publish:
   ```bash
   python -m build
   python -m twine upload dist/*
   ```

## Troubleshooting

- **403 Forbidden**: Check your API token is correct and has upload permissions
- **400 Bad Request**: Package name or version may already exist. Change version number.
- **File already exists**: The version is already published. Increment the version number.

## Security Notes

- Never commit API tokens to git
- Use environment variables or twine's keyring support for tokens
- Consider using `.pypirc` file for configuration (but don't commit it!)

## Example .pypirc (Optional)

Create `~/.pypirc`:
```ini
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = pypi-YourActualTokenHere

[testpypi]
repository = https://test.pypi.org/legacy/
username = __token__
password = pypi-YourTestPyPITokenHere
```

Then you can use:
```bash
twine upload --repository testpypi dist/*
twine upload --repository pypi dist/*
```

