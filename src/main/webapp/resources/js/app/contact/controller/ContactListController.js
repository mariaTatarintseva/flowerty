'use strict';
/*
 * @author Eugene Putsykovich(slesh) Apr 5, 2015
 *
 *	show contact list
 */
angular.module("flowertyApplication.contactModule")

.controller("ContactListController", ["$scope", "$http", "$location", "emailService", "deleteService", "contactListService", "contactSearchService", "stateSaverService", "paginationService", "notificationService",
        function($scope, $http, $location, emailService, deleteService, contactListService, contactSearchService, stateSaverService, paginationService, notificationService) {
            /*
             * grab emails of selected contact and pass they to SendEmailController
             */
            function sendEmail() {
                if ($scope.bundle.state.isempty()) {
                    notificationService.notify("warning", "Please select contacts to send email.");
                } else {
                    emailService.setValue($scope.bundle.state.checkeds);
                    $location.path("send-email");//redirect to email form
                }
            }

            /*
             * remove specific contacts
             */
            function deleteContact() {
            	if ($scope.bundle.state.isempty()) {
                    notificationService.notify("warning", "Please select contacts to delete.");
                    return;
            	} 
                deleteService.deleteContact(
                    $scope.bundle.state.checkeds,
                    function (data) {
                        console.log("contact delete successful");
                        deleteService.deleteIsChecked($scope.bundle.state.ischecked, $scope.bundle.state.checkeds);
                        notificationService.notify("success", $scope.bundle.state.ischecked.length + " contacts success removed!");
                        $location.path("contact-list");
                    },
                    function (data) {
                        console.log("contact delete error. details: " + JSON.stringify(data));
                        notificationService.notify("danger", "Error during deleting contacts!");
                    });
            }

            $scope.bundle = {
                contacts: paginationService.getListBundle(),
                state: stateSaverService.state,
                deleteContact: deleteContact,
                sendEmail: sendEmail
            };

            $scope.bundle.state.reset();
            $scope.pagination = paginationService.getPagination(contactListService.getContactList, true);
            $scope.pagination.getPage(1);

        }]);
