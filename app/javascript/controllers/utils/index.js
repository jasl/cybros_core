function removeClasses(classNames) {
  return classNames.map(function (className) {
    return document.body.classList.contains(className);
  }).indexOf(true) !== -1;
};

function toggleClasses(toggleClass, classNames) {
  const breakpoint = classNames.indexOf(toggleClass);
  const newClassNames = classNames.slice(0, breakpoint + 1);

  if (removeClasses(newClassNames)) {
    newClassNames.map(function (className) {
      return document.body.classList.remove(className);
    });
  } else {
    document.body.classList.add(toggleClass);
  }
};

export {
  removeClasses,
  toggleClasses
}
