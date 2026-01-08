#!/bin/bash
# Script to publish apscheduler-stable to PyPI

set -e

echo "🚀 Publishing dd-apscheduler to PyPI"
echo ""

# Check if we're in a virtual environment
if [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠️  Warning: Not in a virtual environment"
    echo "   Activating venv..."
    source venv/bin/activate
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/ build/ *.egg-info

# Build the package
echo "📦 Building package..."
python -m build

# Check what was built
echo ""
echo "✅ Build complete! Files created:"
ls -lh dist/

echo ""
read -p "Do you want to upload to TestPyPI first? (recommended) [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "📤 Uploading to TestPyPI..."
    python -m twine upload --repository testpypi dist/*
    echo ""
    echo "✅ Uploaded to TestPyPI!"
    echo "   Test installation with:"
    echo "   pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ dd-apscheduler"
    echo ""
    read -p "Did the TestPyPI installation work? Upload to production PyPI? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📤 Uploading to production PyPI..."
        python -m twine upload dist/*
        echo ""
        echo "✅ Successfully published to PyPI!"
    else
        echo "⏭️  Skipping production PyPI upload"
    fi
else
    read -p "Upload directly to production PyPI? [y/N]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📤 Uploading to production PyPI..."
        python -m twine upload dist/*
        echo ""
        echo "✅ Successfully published to PyPI!"
    else
        echo "⏭️  Upload cancelled"
    fi
fi

