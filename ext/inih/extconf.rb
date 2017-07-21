# frozen_string_literal: true

require "mkmf"

$CFLAGS << " -DINI_MAX_LINE=1024 "

create_makefile "ext/inih"
