#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2012-2013 the OpenProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'meeting_minutes'

FactoryGirl.define do
  factory :meeting_minutes_journal do |m|
    m.association :journaled, :factory => :meeting_minutes
  end
end
