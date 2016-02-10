# -*- coding: utf-8 -*-
@example @story

Feature: Testing creation of a partner

  Scenario: Create a partner
    Given I need a "res.partner" with oid: scenario.partner_story1
    And having
      | key  | value            |
      | name | My story partner |
