0. Prerequisites:

- Keywords:

  + `minor`: the new patch has a small range of effect to the entire codebase.
  + `medium`: the new patch has an intermediate range of effect to the entire codebase.
  + `major`: the new patch has a ginormous range of effect to the entire codebase.

1. With a small/tiny or minor change that will not affect codebase's structure:

- Examples: adding comments, adding common utility function, fixing linting error, beautify code formatter, etc.

- Commit convention:

  > ```
  > chore: <commit_message>
  > minor: <commit_message>
  > test: <commit_message>
  > ci: <commit_message>
  > doc: <commit_message>
  > license: <commit_message>
  > script: <commit_message>
  > ```

2. With a medium affection to the codebase's structure, the new patch could apply modification in the approximation with the modules level:

- Examples: modify/extend/enrich old feature, new small features, rearrange order of a module tree, new methodology to appoach the business logical, etc.

- Commit conventions: (inside brackets is optional)

  > ```
  > build: (medium:) <commit_message>
  > build(<feature>): <commit_message>
  > feat: (medium:) <commit_message>
  > feat(<feature>): <commit_message>
  > task: (medium:) <commit_message>
  > task(<feature>): <commit_message>
  > ```

3. With a totally new born features that manage the owner to must release a new patch, or the requirement to upgrade the entire codebase:

- Examples: whole new features that has been built for adapting with new business requirements, the logic code optimization after a long period of maintenance/operation time, etc.

- Commit conventions:

  > ```
  > feat: major: <commit_message>
  > build: major: <commit_message>
  > [release]: <commit_message>
  > ```
