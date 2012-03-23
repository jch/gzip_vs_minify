# Gzip vs Minify

After reading about [javascript source maps](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/), I wanted to see whether it's worthwhile to minify javascript if gzip compression is already used. My guess was that minification would reduce the amount of compression that gzip was capable of doing since it would remove many of the common substrings, but I still wanted to get a sense of how big a difference final file size would be.

## The Setup

I saved the [un-minified javascript from nytimes](http://js.nyt.com/js/app/recommendations/recommendationsModule.js) as hello.js, and created a minified version called hello.min.js with [uglifier](http://rubygems.org/gems/uglifier).

To see the different combinations of using gzip and minification, I wrote a small test that'll fetch the different combinations in test.rb. Here are the results:

```
Uncompressed, unminified: 24166 100%
Uncompressed, minified:   18362 76.0%
Compressed,   unminified:  5632 23.0%
Compressed,   minified:    4530 19.0%
```

It turns out that even with gzip, you can get an additional 4% decrease in file size if you also minify before hand.

I've used a combination of minification and gzip on every project I've worked on, but after running this test, I'm not sure that last 4% of optimization is really worth it. My biggest gripe about minification is that it's hard to debug problems in a staging or production environment because there's no easy way to read the source. Source maps are one way to address this problem, but it's also an extra process to maintain in code. As with any other optimization, developers should consider the tradeoffs in complexity compared with the performance gains before applying this optimization.

### Pros (minify and compress)
* save bandwidth - fewer bytes sent over the wire (matters if you're paying akamai)
* [mobile browser can cache](https://twitter.com/#!/vsync/status/183224352685301760)

### Cons
* hard to debug
* extra infrastructure or extra code


## Notes

If you'd like to try these tests on your own, this is how you set it up:

```
git clone https://github.com/jch/gzip_vs_minify.git
bundle
rackup
# in another terminal
ruby test.rb
```