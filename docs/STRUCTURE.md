# Project Structure

This document describes the structure of the conda-autocomplete project.

```
conda-autocomplete/
├── README.md                    # Main documentation
├── LICENSE                      # MIT license
├── .gitignore                  # Git ignore rules
├── scripts/                    # Installation and utility scripts
│   ├── install.sh              # Main installation script
│   ├── conda_autocomplete.sh   # Bash autocomplete script
│   └── conda_autocomplete.zsh  # Zsh autocomplete script
├── docs/                       # Documentation
│   └── STRUCTURE.md            # This file
└── examples/                   # Usage examples
    └── (future examples)
```

## Directory Description

- **scripts/**: Contains all executable scripts and autocomplete implementations
- **docs/**: Project documentation and guides
- **examples/**: Example configurations and usage demonstrations

## Files Description

- **install.sh**: Interactive installer that detects shell type and installs appropriate autocomplete
- **conda_autocomplete.sh**: Bash-specific autocomplete implementation
- **conda_autocomplete.zsh**: Zsh-specific autocomplete implementation with enhanced features like FZF integration