
#!/usr/bin/env node

function createRef(
  ref: string,
  sha: string
): Promise<string> {
  core.info(`Creating reference ${ref}`);
  const { data: response } = await github.rest.git.createRef({
    ...context.repo,
    ref,
    sha,
  });
  return response;
}

try {
  const ref = await createRef(
    process.env.REF,
    process.env.SHA
  );
  return ref;
} catch (error) {
  console.error(JSON.stringify(error, null, 2));
  if (error.message !== 'Reference already exists') {
    core.setFailed(error.message);
  } else {
    core.info('Reference already exists');
  }
  return;
}