<!---- copyright
OpenProject Meeting Plugin

Copyright (C) 2011-2014 the OpenProject Foundation (OPF)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License version 3.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

See doc/COPYRIGHT.md for more details.

++-->

# Changelog

## 3.0.9

* `#5357` Adapt released plugins to base on plugins functionality
* `#4040` Fix: Referencing work packages with ### in news, forums and meetings does not work
* Fix: Add edit accesskey for wiki

## 3.0.8

* `#4024` Subpages have no unique page titles
* `#4797` Fix: [Subdirectory] Broken Links

## 3.0.7

* `#2259` [Accessibility] linearisation of issue show form (2)

## 3.0.6

* Adaptations for new icon font
* `#2250` [Accessibility] activity icon labels
* `#2759` Fix: [Performance] Activity View very slow
* `#3119` [Migration] Meetings do not migrate planning element references
* `#3329` Refactor Duplicated Code Journals
* added icon for new project menu

## 3.0.5

* fixed cukes

## 3.0.4

* `#2463` Squashed old migrations

## 3.0.3

* `#1790` Adapt Meeting Plugin to the acts_as_journalized changes

## 3.0.2

* `#1602` Copyright notice updates and wiring to specific Core versions because of coming update to acts_as_journalized

## 3.0.1

* `#1673` Fixed missing translation in diff view

## 3.0.0

* `#1554` Execute release

## 3.0.0.rc2

* `#1529` First public release
* `#1551` Fixed bug: Not possible to withdraw invitation

## 2013-07-04 Christian Ratz <c.ratz@finn.de>

	* fix time zones bug

## 2013-06-27 Christian Ratz <c.ratz@finn.de>

	* new pagination
	* fix time zones bug

## 2013-06-21 Christian Ratz <c.ratz@finn.de>

	* Use final plugin name schema

## 2013-06-14 Christian Ratz <c.ratz@finn.de>

	* added dependency to OpenProject core >= 3.0.0beta1

## 2013024 Christian Ratz <c.ratz@finn.de>

	* RC1 of the Rails 3 version
	* This version is no longer compatible with the Rails 2 core

## 2013-03-22 Jens Ulferts <j.ulferts@finn.de>

  * fixes routes
	* removes unnecessary code
	* shows only the users as possible participants who have the required
	  permissions
	* adds missing html_safe
	* fixes mailer i18n issue

## 2013-03-18  Hagen Schink <h.schink@finn.de>

	* Swtiched to version 0.2.5
	* Rails 3.2-ified plug-in
