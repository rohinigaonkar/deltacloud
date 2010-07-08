Feature: Working with storage snapshots
  In order to work with storage snapshots

  Background:
    Given I want to get XML

  Scenario: I want to get list of all storage snapshots
    Given I am authorized to list storage snapshots
    When I request index operation for storage snapshots collection
    Then I should see <STORAGE_SNAPSHOT_COUNT> storage snapshot inside storage snapshots

  Scenario: I want to show storage snapshot details
    Given I am authorized to show storage snapshot '<STORAGE_SNAPSHOT_ID>'
    When I request for '<STORAGE_SNAPSHOT_ID>' storage snapshot
    Then I should get this storage snapshot
    And storage snapshot should have valid href parameter
    And storage snapshot should contain id parameter
    And storage snapshot should contain created parameter
    And storage snapshot should contain state parameter
    And storage snapshot should have storage-volume with valid href attribute
    When I want to get details about storage volume
    Then I could follow storage volume href attribute
    And this attribute should point me to valid storage volume

  Scenario: I want filter storage snapshots by state
    Given I am authorized to list storage snapshots
    When I want storage snapshots with '<STORAGE_SNAPSHOT_STATE>' state
    Then I should get only realms with state '<STORAGE_SNAPSHOT_STATE>'