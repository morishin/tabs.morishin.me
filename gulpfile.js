const gulp = require("gulp");
const exec = require("child_process").exec;

const build = () => {
  console.log("Building...");
  exec("bundle exec middleman build", (_, stdout, stderr) => {
    if (stderr) {
      console.error(stderr);
      return;
    }
    console.log(stdout);
  });
};

gulp.task("watch", () => {
  build();
  return gulp.watch("source/**/*", build);
});
