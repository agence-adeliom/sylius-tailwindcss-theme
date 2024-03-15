const defaultOptions = {
    method: 'POST',
    headers: {
        'Accept': 'application/json, text/javascript, */*; q=0.01',
        'X-Requested-With': 'XMLHttpRequest',
    },
}

export async function fetcher(url, options) {
    return await fetch(url, {
        ...defaultOptions,
        ...options
    });
  }