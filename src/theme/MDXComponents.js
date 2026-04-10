import React from 'react';
import MDXComponents from '@theme-original/MDXComponents';
import useBaseUrl from '@docusaurus/useBaseUrl';

export default {
  ...MDXComponents,

  a: (props) => {
    const isInternal = props.href?.startsWith('/');

    const href = isInternal
      ? useBaseUrl(props.href)
      : props.href;

    return <a {...props} href={href} />;
  },
};