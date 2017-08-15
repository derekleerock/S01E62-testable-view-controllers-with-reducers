# Swift Talk
## Testable View Controllers with Reducers

This is the code that accompanies Swift Talk Episode 62: [Testable View Controllers with Reducers](https://talk.objc.io/episodes/S01E62-testable-view-controllers-with-reducers)

# Modifications (derekleerock)

I found this episode of Swift Talk to be really engaging especially since I had been exposed to the Elm architecture recently. Therefore I wanted to follow along with this refactoring exercise together with Chris and Florian - but since their repo had only the finished product, I've created branches for each step along the way for reference:

- Step1_OriginalCode → This is the starting point if you'd like to follow along from the beginning. (Beginning of video)
- Step2_InitialRefactor → The state of the code after adding the State struct and some computed properties. (~11:06)
- Step3_IntroduceMessages → The state of the code after introducing messages and sending messages to update state. (~19:30)
- Step4_IntroduceCommands → The state of the code after introducing a command to handle loading data from a url. (End of video)
