# Pinwheel

Pinwheel is our small internal project tracker. People belong to one or more accounts (teams or customers), and each account has its own projects. Projects have assigned people, a comment thread, and can be archived when the work wraps up.

## Setup

You need Ruby 3.4 (see `.ruby-version`). Everything runs on SQLite, so there's no database server to install.

```sh
bin/setup --skip-server
bin/dev
```

Then open http://localhost:3000.

`bin/setup` installs gems, creates the databases (including the Solid Queue database) and loads the seed data. It's safe to re-run at any time; if anything goes wrong with the databases, `bin/setup --reset` rebuilds them from scratch. Without `--skip-server` it also starts `bin/dev` when it finishes. `bin/dev` runs the web server, the Tailwind watcher and the Solid Queue worker.

## Seeded logins

All users have the password `password`.

| Name           | Email                | Accounts                                  |
| -------------- | -------------------- | ----------------------------------------- |
| Dana Whitfield | dana@example.com     | Northwind (admin), Globex (member)        |
| Marcus Bell    | marcus@example.com   | Northwind                                 |
| Priya Shah     | priya@example.com    | Northwind                                 |
| Tom Okafor     | tom@example.com      | Globex (admin)                            |
| Lena Ortiz     | lena@example.com     | Globex                                    |

Dana belongs to both accounts, so she's a good one to use for trying the account switcher.

## Emails and pushes in development

- Sent emails: http://localhost:3000/letter_opener
- Push deliveries: http://localhost:3000/dev/push_deliveries (also linked as "Dev" in the footer)

## Tests and linting

```sh
bin/rails test
bin/rubocop
```
