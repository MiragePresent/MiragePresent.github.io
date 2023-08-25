---
layout: post
title: Return early and how it works in examples
date: 2023-08-10 11:52:02
categories: [English only, programming]
---

![Road with exit](/assets/img/early-exit-thumbnail.jpg)
<span class="image-attribute">
	<a href="https://www.freepik.com/free-photo/cluster-street-signs-road-markings-entrance-loop_16226129.htm#query=highway%20exit&position=30&from_view=keyword&track=ais">Image by wirestock</a> on Freepik
</span>

Have you heard about the return early approach? No, it's not when you are 15 and your parents don't allow you to stay late at your friend's and tell you to return by 9 PM. The other name for the return early in programming, and probably more commonly used, is the early exit. Does it ring the bell? Let me tell you about this cool practice in a few examples.

For those who have never heard about early exit you can ask ChatGPT and it probably gives you something like this:

> The early exit is stopping a loop or function before it has finished its execution, based on a specific condition. It allows the program to skip unnecessary steps and improve performance.

I would simplify it by saying once the current result of a function or a loop satisfies the conditions of the action just stop execution right there and return the result.

Modern computers are fast so by using early exit you won't save any noticeable time, energy, or memory but still this approach has other benefits that might help you to be more efficient

## Do not spend your time reading something you don't need

Imagine that I have a script and I want to print how much time it takes to execute it. Pretty simple right? So I calculated the duration in seconds but I want to have its human-readable representations:

```golang
func SecondsToHumanReadable(seconds int) string {
	if (seconds >= 60) {
		leftSeconds := seconds % 60
		minutes := (seconds - leftSeconds) / 60
		return fmt.Sprintf("%d minute(s) %d second(s)", minutes, leftSeconds)
	} else {
		return fmt.Sprintf("%d second(s)", seconds)
	}
}
```

OK, looks good and works as we expect but can we improve it a bit? Here is where the early exit comes into play. 

Let's look at how the example above would look like if I use the early exit:

```golang
func SecondsToHummanReadable(seconds int) string {
	if seconds < 60 {
		return fmt.Sprintf("%d second(s)", seconds)
	}
	leftSeconds := seconds % 60
	minutes := (seconds - leftSeconds) / 60
	return fmt.Sprintf("%d minute(s) %d second(s)", minutes, seconds)
}
```

OK, what is the difference you might wonder? First, the next time you read it and I know that I'm dealing only with seconds I just skip the part that calculates the minutes. Second, I don't spend my time searching where the `if` part ends and the `else` begins. 

This is a simple example with one condition when it comes to several conditions the early exit starts shining much noticeably. OK, Imagine I have a script that reads metadata from a file based on a given file path, but before reading the file I have to make sure I'm not exposing any "non-meta" files in other words I wanna validate the file first:

```golang
func IsMetaFile(file string) bool {
	fileInfo, err := os.Stat(file)
	// 1. File exists and readable
	// 2. Not a directory
	if nil == err && !fileInfo.IsDir() {
		fileExt := filepath.Ext(file)
		// 3. Is an YAML file
		if fileExt == ".yaml" || fileExt == ".yml" {
			fileContent, err := os.ReadFile(file)
			// 4. Must contain metadata
			if nil == err {
				return strings.HasPrefix(string(fileContent), "metadata:")
			}
		}
	}
	return false
}
```

Again, looks fine. But let's compare it with the implementation that uses early exit:

```golang
func IsMetaFile(file string) bool {
	fileInfo, err := os.Stat(file)
	// 1. File does not exist or not readable
	if err != nil {
		return false
	}
	// 2. It's a directory
	if fileInfo.IsDir() {
		return false
	}
	fileExt := filepath.Ext(file)
	// 3. Is not an YAML file
	if fileExt != ".yml" && fileExt != ".yaml" {
		return false
	}
	fileContent, err := os.ReadFile(file)
	// 4. File content cannot be read
	if err != nil {
		return false
	}
	// 5. Does file contain metadata?
	return strings.HasPrefix(string(fileContent), "metadata:")
}
```

In a year if I have to debug this function I read it and I don't have to keep all the conditions in mind. If I know that the file does not exist I don't read what are the other condition because I don't care. If I know that the folder doesn't contain any YAML files again I stop right on the second condition and don't read it further. If I know that file exists then you clearly see how the content of the file must be formatted.

## Better code coverage

The other advantage of using early exit is that when I use it is that I can see what use cases my tests should cover and as a bonus, the test coverage is more accurate as it identifies which negative use cases I haven't covered. See the screenshot below:

![Code coverage examples](/assets/img/early-exit-coverage-example.jpeg)

I only have two tests the first covers the positive use case, and the second a negative use case when the file cannot be found or is not readable but with nested conditions the coverage doesn't show that I'm missing the negative test cases for the file is not a YAML file or file content though I can see them missing when I use early exit and split the conditions.

## Bad design identification

Another profit of using the early exit is that it helps my functions to not overgrow as when I see that I can't put a return without having a nested condition or an else statement then probably I overcomplicate my function or I had some "not optimal" decisions before. Let's look at the example below:

```golang
func MarkUnavailable(device Device) error {
	if device.Type == DEVICE_SENSOR {
		if device.ErrorCode > ERROR_OFFSET_SENSOR && device.ErrorCode < (ERROR_OFFSET_SENSOR+100) {
			device.Unavaliable = true
		}
		return nil
	} else if device.Type == DEVICE_CONNECTOR {
		if device.LastPing > (time.Now().Unix() - 30) {
			device.Unavaliable = true
		}
		return nil
	}
	return errors.New("Unsupported device type")
}
```

As you can see I can't do anything to avoid nested conditions in this function because the availability of a device depends on its type and the function and different rules depending on the type. If you see similar cases in your codebase then I have bad news for you: it's not possible to simplify such a function and if you see that growing in the future then start refactoring as soon as possible. It's a ticking bomb that might bring you a lot of different bugs and hours of debugging your code trying to make it work as expected. 

First, you added something here then something there, then you have to add another condition somewhere inside and so on. Finally, you end up being afraid to touch that code because you don't remember why you need all these conditions and the function is used in so many places so you don't want to break anything. Sure that's a pessimistic scenario but it's quite real and happens quite often to long-living projects. I won't start talking a conversation about code smells this is an example of how early exit helps me see when I might do something wrong.

## Conclusions

Although the early exit seems appealing, it's not a panacea. You shouldn't try to use it everywhere but it could be handy for some cases where you have complex or nested conditions. The code might take more space as you add more return statements and split conditions but you should question yourself if it improves the readability. You write the code once but you read it many times and if the early exit approach helps you understand your code better/faster then it might save you hours of your time at the end.  