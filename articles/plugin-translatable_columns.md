It was just three days ago when I discussed how to [translate columns](/translating-columns). At the moment I was writing it, I was already thinking: "this should be a plugin". So today, I took the liberty and created it.

### Installing

First make sure you're running Rails 2.2 or edge:

``` bash
rake rails:freeze:edge
```

Install the plugin:

``` bash
./script/plugin install git://github.com/iain/translatable_columns.git
```

Create or modify a model to have multiple columns for one attribute:

``` bash
./script/generate model Topic title_en:string title_nl:string title_de:string title_fr:string
```

### Usage

Identify the columns you want to translate:

``` ruby
class Topic < ActiveRecord::Base
  translatable_columns :title
end
```

And you're done!

Create a form like this:

``` erb
<% form_for(@topic) do |f| %>
  <%= f.text_field :title %>
<% end %>
```

And it will save to whatever locale is set in I18n. No hard feelings, nothing to worry about.

### Validating

Validation is of course built in. If you want to validate the presence of at least one of the translations, just call `validates_translation_of`:

``` ruby
class Topic < ActiveRecord::Base
  translatable_columns :title
  validates_translation_of :title
end
```

This will make your record invalid when none of the translated columns exist. It works exactly as
`validates_presence_of`, including **all** its options!

### Customizing

You can change the settings of translatable_columns on both a global level and at individual attribute level. There are two configuration options at the moment, called `full_locale` and `use_default`.

Set the global configuration in your environment file:

``` ruby
# These are the defaults of translatable_columns:
ActiveRecord::Base.translatable_columns_config.full_locale = false
ActiveRecord::Base.translatable_columns_config.use_default = true
```

<h4>full_locale</h4>

With this option you can change which part of the locale is used in the columns. Default is
<u>false</u>, so only the first part of the locale is expected in the column. So a title for en-US
is called title_en and a title for en-GB is also called title_en. When you set `full_locale` to
<u>true</u>, it uses the entire locale, substituting the hyphen with an underscore. This way a title
for en-US is called title_en_us and a title for en-GB is called title_en_gb.

full_locale cannot be set per attribute just now.

<h4>use_default</h4>

With this option you can specify which value will be returned automatically if no proper value has
been found. Default is <u>true</u>, so it will try harder to find a value. It might even be a value
in another language.

You can set this option per attribute if you'd like, to override the global config.

``` ruby
class Topic < ActiveRecord::Base
  translatable_columns :title, :use_default => false
end
```

### Some extras

What if the user has selected a locale which you don't have in the database? In this case it'll
get the column belonging to the I18n.default_locale. Make sure you have a column for this locale,
because you'll be serving a nasty error if even this one isn't present!

You might want to provide multiple languages for a user to fill in at once. This is one way to do it:

``` erb
<% form_for(@topic) do |f| %>
  <% Topic.available_translatable_columns_of(:title).each do |attribute| %>
    <%= f.text_field attribute %>
  <% end %>
<% end %>
```

Happy devving!
