
================================================
iOS Lead Management
http://www.cloudspokes.com/challenge_detail.html?contestID=217
================================================


Video Tutorial:
================================================
http://www.screenr.com/Le7s



Description
================================================
The challenge was to build a simple iOS app with only one purpose: get new leads as fast 
as possible. The app was designed with that scope in mind. 
After the user has been verified with the OAuth protocol the app will show the page to enter 
all the informations for the new lead. Each row is clickable and is opening a page where the 
user can enter free text or pick a value. 
Once all the informations are entered in the form, the user can press the save button and the
app first will check for the required fields, if they are populated the new lead is sent to 
saleforce.com. If the operation is succesfull, the app will ask to attach a photo to the lead.
The user can choose to resize the picture of send the full size. When the upload is done, the 
app will clean the form and it's ready to save another lead.



Main points
================================================
+ the layout for the form to enter a new lead is generated from the schema (limits and labels)
+ the keyboard changes for each field type (text, phone, url)
+ base64 encoding is done on a working thread
+ multiple size for the attachmnet to save some upload time
+ only standard UI components are used to provide the same look&feel of other iOS applications



Code
================================================
The models are the operations via the salesforce.com
- ModelLogin: to verify the credentials
- ModelDescribeSObject: to get information about the fields in the form
- ModelCreate: to send the information to create an SObject 
- ModelAttachment: to attach an image (Base64 encoded)

The controllers
- LeadManagementViewController: is the controller of the form for a new lead
- AddTextViewController: to add free text
- AddPickListViewController: to add the value from a picklist

In ModelLogin.m
- kPersintentToken: if defined, the app will reuse the latest credential without asking (for Development)

In LeadManagementAppDelegate.m
- kSFOAuthConsumerKey: OAuth token (you can customize it here)


3rd party lib
================================================
- iOS toolkit to connect to salesforce.com with the OAuth session
- MBProgressHUD for the activity indicator




