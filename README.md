# Eye2eye

[![codecov](https://codecov.io/gh/fi-ya/eye2eye/branch/main/graph/badge.svg?token=EF86S3KA7W)](https://codecov.io/gh/fi-ya/eye2eye)

This is the final capstone project of the [8th Light Apprenticeship](https://8thlight.com/blog/tags/apprenticeship.html). It started on Monday 22 August 2022 and will last for 15 working days, concluding on Tuesday 13 September 2022. My mentors have taken the role of my client. Prior to this project I had not worked with a functional language, Elixir or Phoenix. 

## Table of Contents 
  - [Prerequisites](#prerequisites)
  - [Run project](#run-project)
  - [Run tests](#run-tests)
  - [Project requirements](#project-requirements)
  - [Implementation requirements](#implementation-requirements)
  - [Style guide](#style-guide)
  - [Demo](#demo)
  - [User stories](#user-stories)
  - [Database Schema](#database-schema)
  - [Learn more](#learn-more)

## Prerequisites
- [Elixir 1.12 or later](https://elixir-lang.org/install.html) 
  - Check version run: `elixir -v`
  - Install via Homebrew run: `brew install elixir`
- [Phoenix](https://hexdocs.pm/phoenix/installation.html) 
  - [Hex package manager](https://hexdocs.pm/phoenix/installation.html#elixir-1-12-or-later)
    - Check version run: `mix -v`
    - Install run: `mix local.hex`
- [NodeJS 16 or above](https://github.com/nvm-sh/nvm#installing-and-updating)
  - Check version run: `node -v`
- [PostgreSQL](https://www.postgresql.org/docs/) v14.4
  - Check version run: `psql -version`
  - Install via Homebrew run: `brew install postgresql` or use [installers](https://www.postgresql.org/download/)

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

**Note:** You can delete your database with `mix ecto.drop`, but make sure your server has stopped before you run the command. To view all the routes for the application run `mix phx.routes`

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
- [x] The user can add any of these products in any amount to a shopping cart, which should be displayed on the page and concurrently updated.
- [x] There is a link to click through to the checkout page, where the user can review their order and click ‘Pay’.
- [x] In this first iteration, we will not incorporate an actual payment system. Instead, the order details should be saved to the database when the user clicks ‘Pay’.
- [x] The user should be able to go to a ‘Previous orders’ page which pulls this data from the database.

## Implementation requirements
- [x] TDD
- [x] CI with linting and tests

Since this is the first iteration of the app, the UI should be clear and functional but it does not require design at this stage, i.e. it should be completely basic. The app only needs to work locally, do not deploy it.Since this is the first iteration of the app, we do not expect any authentication/authorization.

<p align="right">(<a href="#top">back to top</a>)</p>

## Style guide
This project uses [mix format](https://hexdocs.pm/mix/master/Mix.Tasks.Format.html) and  [credo](https://github.com/rrrene/credo). You can find the configuration file for the formatter in the `.formatter.exs` file and code analysis in the `.credo.exs` file.

<p align="right">(<a href="#top">back to top</a>)</p>

## Demo
[Demo](https://user-images.githubusercontent.com/69358550/189679486-82071ee5-8f72-4327-be5e-412821879ebc.mov)

<p align="right">(<a href="#top">back to top</a>)</p>

## User stories
- As a user i want to view all the products with details so that i have the information i need to decide if i want to buy a product
- As a user I want to be able to add a product to my shopping cart so that i can purchase it
- As a user I want to be able to see the shopping cart counter update when I add an item so that i can how many items are in my cart
- As a user I want to be able to see my the shopping cart with any items i have selected when I come back to the website
- As a user I want to be able to see all the items in my shopping cart so that i can see how much everything will cost
- As a user I want to be able to review my order(shopping cart) so that i can remove items i no longer want to buy
- As a user i want to checkout an order so i can purchase the items i have selected
- As a user i want to see if my order was successful so i know my purchase is completed
- As a user I want to be able to see all previous orders with details so that I know what i have purchased

<p align="right">(<a href="#top">back to top</a>)</p>

## Database Schema
<img width="307" alt="Screenshot 2022-09-12 at 19 01 55" src="https://user-images.githubusercontent.com/69358550/189735934-d8a542ed-3ebf-454b-bd4d-acfeb69aab3c.png">

<p align="right">(<a href="#top">back to top</a>)</p>

## Learn more
  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

<p align="right">(<a href="#top">back to top</a>)</p>

## Author

Safia Ali 

