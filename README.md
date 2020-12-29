Cybros Core
====

[![CircleCI](https://circleci.com/gh/jasl/cybros_core.svg?style=svg)](https://circleci.com/gh/jasl/cybros_core)

This is a barebone Rails 6.0 app to show some basic configurations.

I'm used to maintaining a barebone app that helps me build new project quickly,
and this is extracted from my side project initially for sharing my ideas to friends,
but if this is valuable to you, use it freely.

## Goal

I hope this could be a template for new apps, it should be production-ready,
so I'll keep polishing the codebase, follow best practice, keep dependencies up to date.

I don't wanna add too much features especially business-specific,
but I'd like to perfection User system (based on Devise) because most apps need this,
and keep improving UI/UX relates works.

BTW: I'm really hoping someone could extract GitLab's user system.

I list some helps wanted, see below.

## Features

### Classic front-end

Personally, I'm not skilled at front-end and I still prefer classic Rails server-side rendering,
and partially introduce React or Vue for complex pages.

A good example is Gitlab, I also cheat some useful helpers to this app.

#### Webpacker 5 without Sprockets

Webpacker can do all the jobs that Sprockets does,
and has full support of front-end community,
So I remove Sprockets and tune Webpacker allows Assets Pipeline experience.

I do these:

- Remove gems related to Sprockets
- Search and remove `assets` related configs
- `resolved_paths: ['app/assets']` in `config/webpacker.yml`
- `app/javascript/packs/application.js` require all static assets (images, webfonts, etc.)

#### CoreUI with Bootstrap, FontAwesome

See `app/assets/stylesheets/application.scss`

### Application configuration

#### A hack about Rails Credentials

Rails Credentials is a useful feature to store security-sensitive configs.

But we can't bundle `master.key`, and `credentials.yml.enc` isn't readable,
so it's difficult to redistribute the app,
I gave a [PR to Rails](https://github.com/rails/rails/pull/34777) but no respond,
I consistantly think it's useful so I integrate it as a hack, see `bin/rails`.

So you can copy `config/credentials.yml.example` as `config/credentials.yml`,
edit it, then run `rails credentials:encrypt` that will generate `config/credentials.yml.enc` and `config/master.key` for you.

#### A hack about ActionMailer configuration

Unlike `database.yml`, ActionMailer's config separates in many files,
I do a hack that you can config ActionMailer in one place.

See `config/mailer.yml`

Codes in `config/application.rb`

### Implemented a full-feature layouts & views

I don't have art skill but ... at least it works!

#### Overrides Form Helpers to enhance them to support Bootstrap form validation style

The technique is in <https://guides.rubyonrails.org/engines.html#implementing-decorator-pattern-using-class-class-eval>

See `app/overrides/action_view/helpers/form_builder_override.rb`

In addition, see `config/application.rb` for how to require overrides.

#### Don't render ActionView's default error field wrapper

That will break many CSS frameworks.

See `config/initializers/action_view.rb`

#### Default value for model fields

See `app/models/concerns/acts_as_default_value.rb`

Default value of column can only be a static value,
Active Record's `attribute` DSL can set default for field but doesn't have entity context,
Using hooks (such as `after_initilize`) to set default values has edge cases,
you can use `default_value_for` to set default value.

Here's a complex example:

```ruby
default_value_for :role_id,
                    -> (member) {
                      if member.has_attribute?(:tenant_id) || member.tenant
                        member&.tenant&.member_role&.id
                      end
                    }, allow_nil: false
```

#### I18n for `enum`

See `app/models/concerns/enum_attribute_localizable.rb`

Rails doesn't have best practice for `enum` I18n,
I integrate my personal practice.

For example, I have a model `Post` with `status` column for `enum`

```ruby
class Post < ApplicationRecord
  enum status: %i[draft published archived]
end
```

The locale `post.en.yml` looks like

```yaml
en:
  activerecord:
    models:
      post: Post
    attributes:
      post:
        status: Status
        statuses:
          draft: Draft
          published: Published
          archived: Archived
```

To render human readable post's status, you can do like this:

```ruby
Post.human_enum_value(:status, @post)
```

### Undocumented yet

TODO:

## Run the app

- Clone it
- `bundle`
- `yarn`
- `cp config/database.yml.example config/database.yml`
- `cp config/credentials.yml.example config/credentials.yml` & `rails credentials:encrypt`
- `cp config/mailer.yml.example config/mailer.yml`
- `rails db:migrate`
- `rails s`

### Receive Devise confirmation mail

In development, I use `mailcatcher` to receive mails,
run `gem install mailcatcher` to install it.

Open a new terminal, run `mailcatcher`, then follow the instructions

### Set user as admin

- `cp config/settings.yml config/settings.local.yml`
- Put your email into `admin.emails`
- In user menu (right-top of pages), you should see `Administration`

## Troubleshooting

Make sure run `gem update --system` to use latest Rubygem

## Help wanted

- UI/UX design & SCSS & HTML improvement
- Layout for mails
- Coding style & structural improvement
- Try support uploading user avatar using ActiveStorage
- Find bugs
- Docker for deployment, including stages to compiling assets & copy `yml`s, easy to migrate to k8s

## Screenshots

![Sign in page](_screenshots/sign_in_page.png)
![Admin user page](_screenshots/admin_user_page.png)

## License

[MIT License](https://opensource.org/licenses/MIT).
