# Eye2eye

This is the final capstone project of the [8th Light Apprenticeship](https://8thlight.com/blog/tags/apprenticeship.html). It started on Monday 22 August 2022 and will last for 15 working days, concluding on Tuesday 13 September 2022. My mentors have taken the role of my client. Prior to this project I had not worked with a functional language, Elixir or Phoenix. 

## Table of Contents 
  - [Prerequisites](#prerequisites)
  - [Run project](#run-project)
  - [Run tests](#run-tests)
  - [Project requirements](#project-requirements)
  - [Implementation requirements](#implementation-requirements)
  - [File Structure](#file-structure)
  - [Learn more](#learn-more)

## Prerequisites
- [Elixir 1.12 or later](https://elixir-lang.org/install.html) 
- [Phoenix](https://hexdocs.pm/phoenix/installation.html) 
  - [Hex package manager](https://hexdocs.pm/phoenix/installation.html#elixir-1-12-or-later)
  - [Phoenix application generator](https://hexdocs.pm/phoenix/installation.html#phoenix)
- [NodeJS 16 or above](https://github.com/nvm-sh/nvm#installing-and-updating)
- [PostgreSQL](https://www.postgresql.org/download/) v14.4

<p align="right">(<a href="#top">back to top</a>)</p>

## Run project 

To start your Phoenix server:

  * Clone repository `git clone git@github.com:fi-ya/eye2eye.git`
  * Move to project folder `cd eye2eye`
  * Install dependencies with `mix deps.get`
  * Create, migrate & seed your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * Stop Phoenix server with `Ctrl+C Ctrl+C` (yes its twice)

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

***Note:** You can delete your database with `mix ecto.drop`, but make sure your server has stopped before you run the command.*

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

<p align="right">(<a href="#top">back to top</a>)</p>

## Run tests

To run unit tests in the terminal:

* Make sure you are in project folder `cd eye2eye`
* Run tests with `mix test`

<p align="right">(<a href="#top">back to top</a>)</p>

## Project requirements
- [x]  The home page of the website shows 10 products, which are stored and pulled from the database.
- [x] The type of shop can be whatever you want but the products should at least show: name, image, price.
- [ ] The user can add any of these products in any amount to a shopping cart, which should be displayed on the page and concurrently updated.
- [ ] There is a link to click through to the checkout page, where the user can review their order and click ‘Pay’.
- [ ] In this first iteration, we will not incorporate an actual payment system. Instead, the order details should be saved to the database when the user clicks ‘Pay’.
- [ ] The user should be able to go to a ‘Previous orders’ page which pulls this data from the database.

## Implementation requirements
- [x] TDD
- [ ] CI with linting and tests

Since this is the first iteration of the app, the UI should be clear and functional but it does not require design at this stage, i.e. it should be completely basic. The app only needs to work locally, do not deploy it.Since this is the first iteration of the app, we do not expect any authentication/authorization.

<p align="right">(<a href="#top">back to top</a>)</p>

## File Structure
#### Overview
├── _build 
├── assets
├── config
├── deps
├── lib
│   ├── eye2eye
│   ├── eye2eye_web
│   ├── eye2eye_web.ex
│   └── eye2eye.ex
├── priv
└── test

#### Business domain
lib/eye2eye
├── catalog.ex
│   └── product.ex
├── application.ex
├── catalog.ex
├── mailer.ex
└── repo.ex

#### Web-related parts of our application
lib/eye2eye_web
├── controllers
│   └── product_controller.ex
├── templates
│   ├── layout
│   │   ├── app.html.heex
│   │   ├── live.html.heex
│   │   └── root.html.heex
│   └── product
│       └── index.html.heex
├── views
│   ├── error_helpers.ex
│   ├── error_view.ex
│   ├── layout_view.ex
│   └── product_view.ex
├── endpoint.ex
├── gettext.ex
├── router.ex
└── telemetry.ex

<p align="right">(<a href="#top">back to top</a>)</p>
## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

<p align="right">(<a href="#top">back to top</a>)</p>
