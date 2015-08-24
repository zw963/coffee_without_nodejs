# CoffeeWithoutNodejs [![Build Status](https://travis-ci.org/zw963/coffee_without_nodejs.svg?branch=master)](https://travis-ci.org/zw963/coffee_without_nodejs) [![Gem Version](https://badge.fury.io/rb/coffee_without_nodejs.svg)](http://badge.fury.io/rb/coffee_without_nodejs)

CoffeeScript command-line tool without NodeJS.

## Philosophy

Simple & Smart CoffeeScript command-line compiler.

Just do one things, write JavaScript with CoffeeScript elegantly and happily.

 * Install easy, you doesn't need care about NodeJS.
 * Use easy, Just one command, none args needed.
 * Auto watch files changes.
 * Auto SourceMap generation, you can now freely debug CoffeeScript with Firefox/Chrome.d
 * Auto directory generation. 
   e.g.
   - you create a new coffee files: `coffee/models/product.coffee` in your's project root.
   - I will create/update new js files `js/models/product.js` and `js/models/product.map` for you.
   
## Getting Started

Install via Rubygems

    $ gem install coffee_without_nodejs

... or add in Gemfile

    gem "coffee_without_nodejs"

## Usage

    $ coff
    
Or ...

    $ coff some_coffee_files_directory

This will create corresponding js and source map file in same directory as coffee file live in.

![Monitor](http://zw963.github.io/snapshot11.png)
    
If one directory named 'coffee' in you project root, and run `coff` in project root.
will create two new `js` `.map` directory the same level as `coffee` directory,
with cloned directory hierarchy, store js and source map individually.
    
    $ ls
     coffee/
     
    $ coff coffee
    
![Monitor](http://zw963.github.io/snapshot14.png)

Or ...

You always can provide one or more `some_file.coffee' file as arguments.
This will output compiled js content to STDOUT with very pretty format.

    $ coff some_path/file1.coffee

![File](http://zw963.github.io/snapshot12.png)

You still can use redirect `coff some_path/file1.coffee > another_path/file2.js` to
save literal js outout to file2.js

Or ...

`coff` command only support one argument `-e`.

    $ coff -e 'x = 100'
    var x;

    x = 100;

This gem is extract from [Alternative Script Suite](https://github.com/zw963/ass).
You can found a lot of useful and interesting scripts here.

## Support

  * MRI 1.9.3+
  * Rubinius 2.2+

## History

  More update info, please See [CHANGELOG](https://github.com/zw963/coffee_without_nodejs/blob/master/CHANGELOG) for details.

## Contributing

  * [Bug reports](https://github.com/zw963/coffee_without_nodejs/issues)
  * [Source](https://github.com/zw963/coffee_without_nodejs)
  * Patches:
    * Fork on Github.
    * Run `gem install --dev coffee_without_nodejs` or `bundle`.
    * Create your feature branch: `git checkout -b my-new-feature`.
    * Commit your changes: `git commit -am 'Add some feature'`.
    * Push to the branch: `git push origin my-new-feature`.
    * Send a pull request :D.

## license

Released under the MIT license, See [LICENSE](https://github.com/zw963/coffee_without_nodejs/blob/master/LICENSE) for details.
