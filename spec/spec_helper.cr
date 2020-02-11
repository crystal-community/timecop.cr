require "spec"
require "../src/timecop"

Spec.before_each { Timecop.return }
Spec.after_each { Timecop.return }
