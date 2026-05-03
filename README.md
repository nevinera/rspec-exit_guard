# RSpec::ExitGuard

RSpec carefully does not rescue SystemExit, to avoid interfering with language
mechanisms, and for philosophical reasons. The downside of that decision is that
there is a silent threat lurking in your CI - if someone writes a script and then
writes tests that load code from that script and unit-tests them, they will
_eventually_ accidentally trigger an `exit` call inside the code-under-test without
having mocked `exit`. If it's an `exit(0)`, rspec _looks_ like it succeeded, CI passes,
but any tests that _should_ have run after that one (in that same container) _never
ran_.

If you find your coverage numbers fluctuating wildly, or the number of tests that
get run changing between runs, this is more than likely your problem. There are
several ways to detect this situation, but this plugin implements _my_ favorite
of them - we mock exit/abort in a before-each hook, throw a symbol, and catch it
in an around-each hook, producing a failure for the test in question.

## Usage

All you need to do is install the plugin in your Gemfile, and then require it
in `spec_helper.rb`:

```ruby
require "rspec"
require "rspec/exit_guard"
```

If you then call `exit` or `abort` from inside tested code, you'll see an appropriate
failure message, and the rest of the tests will still run:

```bash
TO BE ADDED LATER
```

## Performance

This _does_ add a little bit of overhead. Adding an around-each and a few mocks to
every test is a measurable cost in some suites of tests. In the tests for a
_rails monolith_ though (with factories and significant database interaction) it
is negligible, even for _very very large_ test suites.
