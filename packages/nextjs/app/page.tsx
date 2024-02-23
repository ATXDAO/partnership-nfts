"use client";

import Link from "next/link";
import type { NextPage } from "next";
import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import { NftCard } from "~~/components/nft-card/nftCard";
import { useScaffoldContract, useScaffoldContractRead, useScaffoldContractWrite } from "~~/hooks/scaffold-eth";
import { useAccount } from "wagmi";
import { FormEvent } from 'react'
import { useFetches, useGetAllMetadatas } from "~~/components/nft-card/Hooks";

const Home: NextPage = () => {
  const account = useAccount();

  const { data: partnershipNftContract } = useScaffoldContract({contractName: "ATXDAOPartnershipNft"});

  const { data: mintCount } = useScaffoldContractRead({contractName:"ATXDAOPartnershipNft", functionName:"getMintCount"});

  const { data: adminRole } = useScaffoldContractRead({contractName:"ATXDAOPartnershipNft", functionName: "DEFAULT_ADMIN_ROLE"});

  const { data: hasAdminRole } = useScaffoldContractRead({contractName:"ATXDAOPartnershipNft", functionName: "hasRole", args: [adminRole, account.address]});

  const { writeAsync: mint } = useScaffoldContractWrite({contractName: "ATXDAOPartnershipNft", functionName: "mint", args: ["", BigInt(0)] });

  
  const { data: tokenURIs } = useGetAllMetadatas(partnershipNftContract, mintCount || BigInt(0));

  for (let i = 0; i < tokenURIs.length; i++) {
    tokenURIs[i] = tokenURIs[i].replace("ipfs://", "https://ipfs.io/ipfs/");
  }

  const { data: metadatas } = useFetches(tokenURIs);


  const nfts = metadatas!.map((metadata, index) => (
    <NftCard key={index} nft={metadata}/>
  ));


  async function onFormSubmit(event: any) {
    event.preventDefault()
    await mint({args: [event.target[0].value, BigInt(0) ]});
  }

  let adminOutput;
  if (hasAdminRole) {
    adminOutput = <div className="flex items-center justify-center">
      <form onSubmit={onFormSubmit}>
        <div className="flex flex-col items-center justify-center space-y-1">
          <label htmlFor="recipient" className="block mb-2 text-sm font-medium text-gray-900 dark:text-white">Recipient</label>
          <input type="text" id="recipient" className="bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"/>
          <button type="submit" className="text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 me-2 mb-2 dark:bg-blue-600 dark:hover:bg-blue-700 focus:outline-none dark:focus:ring-blue-800">Mint NFT</button>
        </div>
      </form></div>
  }

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        {
          adminOutput
        }
        <div className="grid grid-cols-2 space-x-1 space-y-1">
        {
          nfts
        }
        </div>
      </div>
    </>
  );
};

export default Home;
