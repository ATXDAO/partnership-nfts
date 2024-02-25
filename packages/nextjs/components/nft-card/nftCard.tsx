interface Nft {
  name?: string;
  description?: string;
  image?: string;
}

interface NftCardProps {
  nft: Nft;
}

export function NftCard(props: NftCardProps) {
  if (props.nft && props.nft.image) {
    props.nft.image = props.nft.image.replace("ipfs://", "https://ipfs.io/ipfs/");
  }

  //flex flex-col items-center justify-center text-center bg-black max-w-xs rounded-lg bg-sky-900 m-1
  return (
    <div className="flex flex-col items-center justify-center text-center bg-black rounded-lg bg-sky-900 m-5">
      <div className="m-4">
        <p className="m-0 font-bold">Name</p>
        <p className="m-0 text-xl">{props.nft.name}</p>
      </div>
      <img className="rounded-lg" src={props.nft.image} width={128} height={128} />
      <div className="m-4">
        <p className="m-0 font-bold text-size-xl">Description</p>
        <p className="m-0 text-xs"> {props.nft.description}</p>
      </div>
    </div>
  );
}
