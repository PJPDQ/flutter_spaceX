# spacex_project

SpaceX Flutter is a mobile Application to display the detailed page of each launch that user sees. It will shows the detailed specification from the provided URL. The data is publicly given by SpaceX. 

The architecture used in this project is MVC framework (Model, View, Controller). This is used in order to achieve better readability for different views, modifying data without affecting the entire model and allowing better asynchronous data.

The choice of design pattern used in this project is Singleton pattern because the complexity of the project seems to suitable for the pattern. This way, it will provide easy accessibility directly without instantiate the object of class.

The assumption made in this project are:
1. The minimal information only includes the launch ID and name
2. Rocket Details extract from the API is limited in order to display the most crucial information.
3. Flutter version used may differ, the version for this project is 2.7.0. 
4. Following the dependencies, their versions are chosen depending on the project's flutter version.

I hope you like it.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
