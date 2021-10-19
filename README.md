# flutter_gallery_demo

Demonstration of coupling InteractiveViewer and PagaView in Flutter.

It can achieve a behaviour which the user's single tap actions are recognized as pan action on a zoomed in page. Once the zoomed in page reached its boundaries, the users can swipe to other pages by a horizontal swipe.

## Limitations

1. The action must stop once at the page boundary before it can swipe to other pages. Beyond the stop, any successive horizontal swipe is recognized as a swipe to other pages but not a pan inside the page until the user cancels the swipe. If the successive action beyond the stop is a gesture zoom while keeping the page at the boundary, the next horizontal swipe is still recognized as a swipe to other pages.
2. If the user cancelled the swipe, there is a 'deadlock' period that the action can be re-recognized as a pan inside the page instead of a horizontal swipe to other pages.

## Demo
https://user-images.githubusercontent.com/67048376/137888934-8c74a2b7-33e1-44cc-84c8-0178c357746f.mp4
