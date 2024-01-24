# Contribution guidelines

**Note**: This document contains contribution guidelines for the SOMA-B2B-SAAS dbt project.

## Getting started with development

### Setup

#### (1) Clone the repository

```
git clone git@github.com:Levers-Labs/SOMA-B2B-SaaS.git
cd SOMA-B2B-SaaS
```

#### (2) Create then activate a virtual environment

```
python3 -m venv venv
source venv/bin/activate
```

#### (3) Install requirements

```
pip install -r requirements.txt
```

#### (4) Create your profiles.yml

```
cp profiles.example.yml profiles.yml
```

#### (5) Install DBT packages

```
dbt deps
```

You're done. Running dbt will now run the code in your local repository.
