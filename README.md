## What to improve:
- [x] Refactor `NomineesListManager` to conform to a protocol-based structure. (PR: https://github.com/musicabbage/ios-developer-test-cube-academy/pull/9)
- [x] Fix the UI of `NominationForm` by:
    - Highlighting texts for the "process" field's title.
    - Adding a divider between form fields.(PR: https://github.com/musicabbage/ios-developer-test-cube-academy/pull/9)
- [x] Extract duplicate UI code into properties or extensions. (PR: https://github.com/musicabbage/ios-developer-test-cube-academy/pull/9)
- [ ] Add animations to `ConfirmLeaveView`.
- [ ] Enhance error handling. (Needs more details)


---

# Cube Academy - iOS Task

## Task

For this task, you'll need to complete an iOS application using Swift and SwiftUI, following the provided designs and API documentation.
To get you started, a basic app setup including colours, fonts, text styles, shadows etc, has been provided for you to work from.

Complete what you can in the time that you have been given, but don't stress too much if you don't finish absolutely everything. We're more interested in the quality of your work, and the range of skills that you demonstrate.

### The App:

The app should allow the user to create, submit, and view their nominations for Cube of the Month.

- iOS designs: [Figma](https://www.figma.com/file/BAOzJacpI4IemeawyFlw5j/Mobile-Mini-Task-flow?type=design&node-id=3088-44039&mode=design&t=wgGz06wMsoOdDdnb-4)
- API documentation: [OpenAPI docs](https://cube-academy-api.cubeapis.com/docs)

The app is made up of three screens:
- **The home screen**, where the user can see can see a list of their submitted nominations.
  - This should be populated by data taken from the API. For new users, the data will be empty and so will display the empty state.
- **The nomination form**, the screen where the user can create and submit their nomination.
  - Once the form has been completed and submitted, the user's nomination should be submitted via the API.
- **The nomination submitted screen**, thanking the user for their submission.
  - When the user returns to the home screen, their submitted nomination should be present.

### API Authentication

You need to include an Authorization header to your API calls. The API uses a Bearer token for Authorization.
Since there isn't a login page in-app, you need to call the register/login endpoint from a software like postman and store the returned Auth Token (somewhere like the Info.plist).

### Notes
- Feel free to use any additional third-party frameworks, such as Alamofire.
- You're welcome to make changes to any and all of the initial code we have provided you.
- Follow the designs closely, but where exact behaviour isn't clear, use your best judgment for user-friendly and intuitive functionality.

### What do we expect from the app? 
- The app should demonstrate good use of Swift technologies. 
- We're looking for an organised, clean, readable, and documented codebase.
- Try to add comments about your decisions. Communicate with us about your choices and reasoning.
- Before reviewing the code, we run and test the app. So make sure you do enough testing to be confident of the app's performance.
- Good use of our pre-setup colours, styles, and components.
- Good use git / version control.

### The task will be marked on the following aspects:
-	Technical ability - how good the code quality is.
-	Attention to detail - how close the end result is to the designs.
-	Organisational skills - how clean and readable the codebase is.
-	Overall solution - how well it accomplishes the task.

## Submission
For submission, fork this repository and send us the link to your git repository to [cubeacademy@3sidedcube.com](mailto:cubeacademy@3sidedcube.com?subject=Cube%20Academy%20Test)
(If you don't like to use github, you can simply clone this project and copy the files into your favourite repository and give us the url to that. Or even zip it up and send it that way. Just make sure we have access to it.)

## Questions?

If you have any questions about any of the above please get in touch with us at [cubeacademy@3sidedcube.com](mailto:cubeacademy@3sidedcube.com?subject=Cube%20Academy%20Test)


