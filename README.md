# README

## Setup

### Ruby, Node.js, Python

Make sure you have ruby, nodejs and python installed, with versions specified in `.tools-versions`

On MacOS I recommend using `asdf` to install them.

When installing python make sure to install it with "--enable-shared" option.

```sh
asdf install ruby 3.2.2
asdf install nodejs 16.17.0
PYTHON_CONFIGURE_OPTS="--enable-shared" asdf install python 3.10.6
```

### Env variables

Copy `.env.example` to `.env.local` and fill it with appropriate environment variables.

- OPENAI_API_KEY - your openai access token (https://platform.openai.com/account/api-keys)
- RESEMBLE_API_KEY - your resemble.ai access token (https://app.resemble.ai/account/api)
- RESEMBLE_VOICE_ID - one of the voice uuids available on your account (find them here: https://docs.app.resemble.ai/docs/resource_voice/all)
- RESEMBLE_PROJECT_ID - one of your project uuids available on your account, clips will be stored there (find projects here https://docs.app.resemble.ai/docs/resource_project/all)
- BASE_URL - useful to test audio file generation in localhost. Point it to your ngrok url so the app can receive external webhooks from resemble.ai. Otherwise set it to localhost:3000.

### Database setup

Create dev and test database

```sh
bin/rails db:create
```

### Static files setup

Copy `book.pdf`, `book.pdf.embeddings.csv` and `book.pdf.pages.csv` to `static_files` dir.

## Testing

Nothing special. Just run the following command.

```sh
 bin/rails test
```

## Local development

Start Vite dev server

```sh
bin/vite dev
```

Start Rails server

```sh
bin/rails s
```
