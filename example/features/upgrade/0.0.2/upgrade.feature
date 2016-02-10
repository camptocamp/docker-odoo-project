# -*- coding: utf-8 -*-
@upgrade_0.0.2

Feature: upgrade 0.0.2

  Scenario: upgrade 'base' module
   Given I update the module list
   Given I install the required modules with dependencies:
     | name |
     | base |
   Then my modules should have been installed and models reloaded
