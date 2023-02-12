# sqm-ios-technical-test
The test is designed to be completed in a maximum of **1 hour**.
 
The evaluation will be based on the ability of the candidate to understand an existing codebase and contribute to it.
Special attention should be paid to **memory management**.

The test project's goal is to evaluate your skills and experience level. 
Please do not include external framework and do not copy-paste external code. 

## Description 
This app is using a web service to display a list of quotes of a market. The user can additionally decide to locally add or remove a quote from her local favorites by tapping on a button on the detail view.
 
## Everything on the project can be modified

## Tasks
 * Parse the quotes returned by the service called.
 * Display the list of quotes in 'QuotesListViewController'. Each item of list must display the following properties: 'name', 'last', 'currency', 'readableLastChangePercent' and if the quote is in favorites (ex: [sketch](../master/cell_sketch.png)). Favorites images are already provided in project.
 * 'readableLastChangePercent' text color must be the same color as indicated in the property 'variationColor'.
 * When the user taps on an item, 'QuoteDetailsViewController' should be displayed with the associated quote details.
 * Implement the local favorites system handling.

## Deliver
* Create a repo on github.
* Define the following code as master
* Create a branch to do the test
* Create a PR with your code changes targetting master to complete the test
