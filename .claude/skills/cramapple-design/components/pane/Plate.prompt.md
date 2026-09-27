One-line: the fixed plate frame and its three-pane grid — every CramApple screen starts here.

```jsx
<Plate caption="CramApple · AP Statistics · Unit 2">
  <Masthead course="AP Statistics" />
  <Breadcrumb items={[…]} />
  <PlateGrid>{scoringPane}{questionPane}{referencePane}</PlateGrid>
  <StudyMap open={mapOpen} … />
</Plate>
```

`overflow: hidden` is deliberate. If content does not fit, restructure — never add a scroller.
