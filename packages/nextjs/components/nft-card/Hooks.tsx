import { useEffect, useState } from "react";

export function useGetAllMetadatas(contract: any, mintCount: bigint) {
  const [data, setData] = useState<any[]>([]);

  useEffect(() => {
    async function get() {
      const arr = [];
      for (let i = 0; i < mintCount; i++) {
        const result = await contract?.read.tokenURI([i]);
        arr.push(result);
      }

      setData([...arr]);
    }
    get();
    // eslint-disable-next-line react-hooks/exhaustive-deps
}, [contract?.address, mintCount]);

  return { data };
}

export function useFetches(uris: string[]) {
  const [data, setData] = useState<any[]>([]);

  useEffect(() => {
    async function get() {
      const arr = [];
      for (let i = 0; i < uris.length; i++) {
        try {
          const response = await fetch(uris[i]);
          const responseJson = await response.json();
          arr.push(responseJson);
        } catch (e) {
          console.log("Could not fetch URI");
          arr.push({});
        }
      }

      setData([...arr]);
    }
    get();
  }, [uris]);

  return { data };
}
