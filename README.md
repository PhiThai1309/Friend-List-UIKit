# Friend-List-UIKit
An UIKit application that manage a list of friends available via GOREST API


<p align="center">
  <img width="250" alt="image" src="https://user-images.githubusercontent.com/71892904/225561828-57806693-8391-4401-ba8b-0feb68477ecf.png">
  <img width="250" alt="image" src="https://user-images.githubusercontent.com/71892904/229410530-6239f9ea-333c-4541-a871-34882b429546.png">
  <img width="250" alt="image" src="https://user-images.githubusercontent.com/71892904/225863043-c838a8c8-cee6-41c5-acbd-3b05fb8e7427.png">
</p>

## Table of contents

- [Overview](#overview)
- [Functionalities](#Functionalities)
- [Limitations](#Limitations)
- [Built with](#built-with)
- [Author](#author)
- [References](#References)


## Overview

This is a small project that I develop to learn about UIKit and how to perfrom a HTTPs request using Swift. This application will fetch a list of 10 people and render it into a table view. User will be able to add, update as well as delete new friend and changes will reflect automatically in the table view.

### Functionalities

- User should be able to add new friends and the system will update the API accordingly
<p align="center">
  <img width="300" alt="image" src="https://user-images.githubusercontent.com/71892904/229410530-6239f9ea-333c-4541-a871-34882b429546.png">
</p>

- User will be able to delete friend in the main screen and will trigger the API to reflect these changes
<p align="center">
  <img width="300" alt="image" src="https://user-images.githubusercontent.com/71892904/229403210-0522ec22-7209-4de0-854e-b9b5c32f9971.png">
  <img width="300" alt="image" src="https://user-images.githubusercontent.com/71892904/229403226-be724104-d3a5-47bd-8837-d0d5a7e77b76.png">
</p>

- User can view the details of each friend as well as update their information in the details View. The updated information will also trigger the API to change accordingly
<p align="center">
  <img width="300" alt="image" src="https://user-images.githubusercontent.com/71892904/225863623-8ee4c4e9-d8f4-47df-8f52-35413c0a91d1.png">
  <img width="300" alt="image" src="https://user-images.githubusercontent.com/71892904/225864310-010bb93f-cc15-46cb-8a6f-dd8c37ad6e84.png">
</p>

## Limitations
- The host API is not responsive and frequently crash. To fail safe this, the application is desgin to prompt the user with an alert when user perform an action during the down time of the hosted API.
<p align="center">
  <img width="300" alt="image" src="https://user-images.githubusercontent.com/71892904/225864876-956e2e7a-aaf5-43d9-b17d-786d588512c4.png">
</p>


### Built with

<p align="center">
  <img src="https://skillicons.dev/icons?i=swift" />
  <img src="https://skillicons.dev/icons?i=postman">
</p>

- Swift
- Post man to test the API
- Link to API: https://gorest.co.in/

## Author
- Thai Manh Phi: Total contribution: 100%

## References
All references is inside the project

