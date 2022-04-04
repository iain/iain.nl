If you're anything like me, you can never remember the argument order for
`alias_method`. I always think to myself "it's the other way around than I think
it is", but then end up doing it wrong anyway.

So here is my mnemonic for remembering it:

``` ruby
alias_method :alias, :method
```

The method name itself is the argument order. First the name of the alias, then
the name of the actual method.

Need some more information about `alias` vs.
`alias_method`? There is a great post on that on
[bigbinary.com](https://www.bigbinary.com/blog/alias-vs-alias-method).
